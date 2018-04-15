include("functions.jl")
# A is just a 67 x 67 graph 
A = zeros(Int64,length(labels),length(labels))

for eid = 1:length(alledges)
    a = alledges[eid]
    for neighbor = 1:length(a[2])
        i,j = find_adjacency_index(a[1],a[2][neighbor],labels)
        A[i,j] = 1
    end
end
A = sparse(A)
fplot = graphplot(A,xy;yflipval=true)