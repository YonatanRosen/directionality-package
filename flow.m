function score = flow(edge_list,block_size,threshold)

% Receives:	
%	edge_list  - a binary directed graph in the format of N*2 list of edges.
%	             An edge (i,j) is a link from j to i
%	block_size - optional parameter. The network distances are calculated
%	             using BFS. The BFS function receives block of nodes as input.
%	             Increasing the block size would speed performance but will require more
%	             memory. default value is 10^4.
%	threshold  - optional parameter. Vertices that have very small basin
%                (for a given vertex, union of all vertices in the incoming
%                and outgoing direction) below the treshold have zero score.
%                This parameter has neglibe difference in real networks,
%                see supplementary. default value is 0.05.
%
% Returns: 
%	score - the flow score.			-

% Reference:
% Yonatan Rosen and Yoram Louzoun. "Directionality of real world networks as predicted by path length in directed and undirected graphs." Physica A: Statistical Mechanics and its Applications 401 (2014): 118-129.

addpath(genpath(pwd)); % add subfolders to current path
if ~exist('block_size','var')
    block_size = 10^4;
end
if ~exist('threshold','var')
    threshold = 0.05;
end

g = ObjectCreateGraph(edge_list);
NodeIDs = GraphNodeIDs(g);
n = length(NodeIDs);
m = length(g.Data);
score = zeros(1,n);

% h = the derived undirected graph
t = zeros(2*m,2);
t(1:m,:) = g.Data(:,1:2);
t((m+1):(2*m),1) = g.Data(:,2);
t((m+1):(2*m),2) = g.Data(:,1);
t = unique(t,'rows');
h = ObjectCreateGraph(t);

Distance = ceil(10*log(n));

if n<=block_size
    blocks = cell(1);
    blocks{1} = NodeIDs;
    num_blocks = 1;
else
    num_blocks = ceil(n/block_size); 
    blocks = cell(1,num_blocks);
    for i=1:num_blocks-1
        blocks{i} = NodeIDs((i-1)*block_size+1:i*block_size);
    end
    blocks{num_blocks} = NodeIDs((num_blocks-1)*block_size+1:end);
end

for k=1:num_blocks
    Neighbours = mexNodeSurroundings(g,blocks{k},Distance,'direct');
    Neighbours_inv = mexNodeSurroundings(g,blocks{k},Distance,'inverse');
    Neighbours_und = mexNodeSurroundings(h,blocks{k},Distance,'direct');
    for i=1:length(blocks{k})
        emptyCells = cellfun('isempty', Neighbours{i});
        Neighbours{i}(emptyCells) = [];Neighbours{i}=Neighbours{i}(2:end);
        
        emptyCells = cellfun('isempty', Neighbours_inv{i});
        Neighbours_inv{i}(emptyCells) = [];Neighbours_inv{i}=Neighbours_inv{i}(2:end);
      
        out_basin = cell2mat(Neighbours{i});
        in_basin = cell2mat(Neighbours_inv{i});
        u = union(out_basin,in_basin);
        if ismember(blocks{k}(i),u) 
            basin_size = length(union(out_basin,in_basin))-1;
        else
            basin_size = length(union(out_basin,in_basin));
        end
               
        if basin_size > threshold*n
            emptyCells = cellfun('isempty', Neighbours_und{i});
            Neighbours_und{i}(emptyCells) = [];Neighbours_und{i}=Neighbours_und{i}(2:end);
            dists_und = zeros(1,n);
            dists_dir = zeros(1,n);          
            for j=1:length(Neighbours{i})
                dists_dir(Neighbours{i}{j}) = j;
            end
            for j=1:length(Neighbours_und{i})
                dists_und(Neighbours_und{i}{j}) = j;
            end 
            dists_und(blocks{k}(i))=0;
            dists_dir(blocks{k}(i))=0;
            t = dists_und./dists_dir;
            t(~isfinite(t))=0;
            score(blocks{k}(i)) = sum(t)/basin_size;
        else
            score(blocks{k}(i)) = 0;
        end        
    end
end
    
end






