anim = @animate for elid = 1:size(daytuples,1)
    
    dayid = daytuples[elid,1]
    fid = daytuples[elid,2]    
    T1 = T[dayid][fid]
    
    posid = T1.>0
    ei,ej,x = findnz(posid)
    x = nonzeros(T1[posid])
    
    # option to normalize by the maximum overall
    mapx = x./maximum(x)
    # mapx = x./maxpostransfer

    kval = rep/daytuples[elid,3]
    
    curr_colors = cmap(mapx)
    mapped_colors = [RGB(curr_colors[i,1],curr_colors[i,2],curr_colors[i,3]) for i=1:size(curr_colors,1)]
    
    lx = [xy[ei,1]';xy[ej,1]']# each column is the x values of an edge (ei,ej)
    ly = [xy[ei,2]';xy[ej,2]']# each column is the y values of an edge (ei,ej)
    
    f = plot(leg=false, axis = false ,yflip=true, leg=false, colorbar=true)
#     scatter!(f,xy[:,1],xy[:,2],color=:black)
    
    for i = 1:length(x)
        plot!(f,lx[:,i],ly[:,i],color = mapped_colors[i], linewidth = 2)
    end
    MPOINTS = zeros(2,length(x))
    map(i -> MPOINTS[:,i] = find_kpoint(lx[:,i],ly[:,i],kval),1:length(x))
    scatter!(f,MPOINTS[1,:],MPOINTS[2,:],color=:white,linewidths=0)#,markersize=1.5,alpha=0.1)
    
    @show fid
    strval = join(["day = ",dayid," hour = ", fid])
    title!(strval)
    @show strval
    
    ## find colors to map:
    ci = cmap(0:0.01:1)
    mi = [RGB(ci[i,1],ci[i,2],ci[i,3]) for i=1:size(ci,1)]
    scatter!(f,xy[1:2,1],xy[1:2,2],marker_z = 0:1,color = ColorGradient(mi))
    scatter!(f,xy[:,1],xy[:,2],color=:black)
end
