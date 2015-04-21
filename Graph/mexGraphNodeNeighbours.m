function [Neightbours,varargout] = mexGraphNodeNeighbours(Graph,NodeIDs,Distance,Direction)
% Returns the list of nodes being at the specified Distance from the Node when shortes pathes are considered
%
% Receive:
%	Graph		-	Graph Struct	-	Struct created with ObjectCreateGraph function (probanly called by GraphLoad).
%	NodeIDs		-	integer			-	(optional)the ID of the node for whitch the neighbours are searched.
%					vector			-	List of IDs, in this case cell array lists of neighbours is returned.
%										default  - [] (computed for all graph nodes). 
%	Distance	-	integer			-	(optional)The distance at witch to look. The computation time may increas with the distance dramatically. Default: 0
%	Direction	-	string			-	(optional) Either 'direct',  'inverse' or 'both'. Case insensitive. The incoming or outgoing links are 
%										followed as a function of this parameter. Default: 'direct'
%
%
%
% Returns: 
%	Neightbours	-	cell array		-	Each cell contains the least of nodes reachable from the corresponding node in NodeIDs 
%	varargout   -	NodeIDs			- (optional) list of node ids. 
% 
% See Also:
%	ObjectCreateGraph , GraphLoad
%																										
%  
%
%