load c_elegans;
h = sparse(g(:,1),g(:,2),ones(length(g),1),max(g(:)),max(g(:)));% convert edge list to sparse matrix
g = [g(:,2), g(:,1)]; % in the complex networks toolbox the edge (i,j) is direct link from j to i while in the c elegans data it is a link from i to j
f = flow(g);
y = hierarchy_energy(h);
