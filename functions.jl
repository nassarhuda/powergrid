using Plots
pyplot(size=(600,300))
include("eia_network_data.jl")
include("eia_extract_data.jl")
# includes the following:
# xy (location on map)
# labels (labels[i] is node i in the adjacency matrix)
# alledges (adjacency list)

function find_midpoint(xvals,yvals)
    xval = sum(xvals)
    yval = sum(yvals)
    return [xval/2,yval/2]
end

function find_kpoint(xvals,yvals,k)
    dx = abs.(xvals[1]-xvals[2])/k
    dy = abs.(yvals[1]-yvals[2])/k
    
    if xvals[1] < xvals[2]
        xval = xvals[1] + dx
    else
        xval = xvals[1] - dx
    end
    
    if yvals[1] < yvals[2]
        yval = yvals[1] + dy
    else
        yval = yvals[1] - dy
    end
    
    return [xval,yval]
end

function graphplot(A,xy;yflipval=false)
    f = plot(leg=false, axis = false)
    ei,ej,w = findnz(triu(A))
    lx = [xy[ei,1]';xy[ej,1]';NaN*ones(1,length(ei))]
    ly = [xy[ei,2]';xy[ej,2]';NaN*ones(1,length(ei))]
    for i = 1:length(w)
        plot!(f,lx[:,i],ly[:,i],color = :black, linewidth = 1)
    end
    scatter!(f,xy[:,1],xy[:,2],color = :black,yflip=yflipval)
    return f
end

find_adjacency_index(label1,label2,labels) = (findfirst(labels.==label1),findfirst(labels.==label2))

function generate_hourly_data(data,idata,d1,alldates_length)
    newdates = d1:Dates.Day(1):d1+Dates.Day(alldates_length-1)
    alldates = Dates.format.(newdates,"yyyymmdd")
    
    T = Array{Array{SparseMatrixCSC{Int64,Int64},1}}(length(alldates))
    for i = 1:length(alldates)
        T[i] = Array{SparseMatrixCSC{Int64,Int64}}(24)
        for j = 1:24
            T[i][j] = spzeros(length(labels),length(labels));
        end
    end
    
    # T[i][j] is T[<day i>][<hour j>]
    for curi = 1:length(alldates)
        curdate = alldates[curi]
        exchange = idata[curdate];
        newlabels = intersect(collect(keys(exchange)),labels)
        
        for i = 1:length(newlabels)
            curlabel = newlabels[i]
            ei = findfirst(labels.==curlabel)
            curexchange = idata[curdate][curlabel]
            for station in keys(curexchange)
                ej = findfirst(labels.==station)
                if ej != 0
                    # idata["20180131"][curlabel]["NWMT"] # this has 24 values
                    # just for the first one hour:
                    for hr = 1:24
                        v = idata[curdate][curlabel][station][hr]
                        if typeof(v) == Int64
                            T[curi][hr][ei,ej] = v
                        end
                    end
                end    
            end
        end
    end
    return T
end