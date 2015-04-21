function GraphLayout = GraphPlotGraphLayout(GraphLayout,varargin)
% Draws the graph based on the layout. 
%
%
% Receieves:
%   GraphLayout - structure - the details necessary to plot the graph
%   varargin        -   FLEX IO -   The input is in FlexIO format.  The following parameters are allowed:
%                                       Parameter Name          |  Type         |  Optional |   Default Value |   Description
%                                           Directional         |   bool        |    yes    |   1             | specifies wheather the graph is directional or not  
%                                           ShowMenuBar         |   bool        |    yes    |   false         | specify whether to remove the figure menu bar. Effective only when the figure is created. 
%                                           NodesOnTop          |   bool        |    yes    |   true          | if true, the nodes are plotted on top of the edges. 
%                                           NodeProperties      |cell of structs|    yes    |   {}            | list of structs, each containing details for the node shape and node ids.   struct('IDs',[],'Shape','circle','LineWidth',2,'LineColor',[0 0 0],'FillColor',[0.3 0.3 0.3])
%                                           EdgeProperties      |cell of structs|    yes    |   {}            | list of structs, each containing details for the node shape and node ids.   struct('IDs',[],'LineWidth',2,'LineColor',[0 0 1]); 
%
%
% Returns:
%   GraphLayout - structure - the details necessary to plot the graph, figure handle and handles of all graph elements. 
%
% See Also:
%   ObjectCreateGraph,LoadGraph, GraphToGraphViz, GraphLoadGraphLayoutPlain
%
% Example:
%{
    GraphLayout = GraphLoadGraphLayoutPlain(Graph, 'Graph.dot.plain')
    GraphLayout = GraphPlotGraphLayout(GraphLayout,'ShowMenuBar',true,'NodesOnTop',true);
%}

%% initialize
error(nargchk(2,inf,nargin));
error(nargoutchk(0,1,nargout));

if ~FIOProcessInputParameters(GetDefaultInput)
    error('The default input is not FlexIO compatible');
end
if ~FIOProcessInputParameters(varargin)
    error('The input is not FlexIO compatible');
end

%% parameters
BackgroundColor = [1 1 1];
DefaultNodeProperties = struct('IDs',[],'Shape','circle','LineWidth',2,'LineColor',[0 0 0],'FillColor',[0.3 0.3 0.3]); 
DefaultEdgeProperties = struct('IDs',[],'LineWidth',2,'LineColor',[0 0 1]); 
if isstruct(NodeProperties), NodeProperties  = {NodeProperties}; end
if isstruct(EdgeProperties), EdgeProperties  = {EdgeProperties}; end

NodeProperties{end+1} =DefaultNodeProperties;
EdgeProperties{end+1} = DefaultEdgeProperties; 
%% create figure; 

if ~isempty(GraphFigureHandle), GraphLayout.Figure.GraphFigureHandle = GraphFigureHandle; end
if ~isfield(GraphLayout.Figure, 'GraphFigureHandle') || isempty(GraphLayout.Figure.GraphFigureHandle) || ~ishandle(GraphLayout.Figure.GraphFigureHandle)
        GraphLayout.Figure.GraphFigureHandle = figure; 
        set(GraphLayout.Figure.GraphFigureHandle,'Color',BackgroundColor);        
        if (~ShowMenuBar),  set(GraphLayout.Figure.GraphFigureHandle,'Color',BackgroundColor,'MenuBar','none');    end
        GraphLayout.Figure.GraphAxisHandle = gca;
        set(GraphLayout.Figure.GraphAxisHandle,'XTick',[],'YTick',[],'XLim',[0 GraphLayout.Graph.Size(1)],'YLim',[0 GraphLayout.Graph.Size(2)] , ...
            'XColor',BackgroundColor,'YColor',BackgroundColor,'Position',[0 0 1 1] , 'XTickMode','manual', 'YTickMode','manual','XTickLabelMode','manual','YTickLabelMode','manual')
        GraphLayout.Edges.Handles(:) = NaN;
        GraphLayout.Nodes.Handles(:) = NaN;
else
    figure(GraphLayout.Figure.GraphFigureHandle); 
end

%% Plot figure; 
if NodesOnTop
    GraphLayout = PlotEdges(GraphLayout,EdgeProperties); 
    GraphLayout = PlotNodes(GraphLayout,NodeProperties);
else
    GraphLayout = PlotEdges(GraphLayout,NodeProperties); 
    GraphLayout = PlotNodes(GraphLayout,EdgeProperties);
end
set(GraphLayout.Figure.GraphAxisHandle,'XTick',[],'YTick',[]);

end % GraphPlotGraphLayout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GraphLayout = PlotEdges(GraphLayout,EdgeProperties)
     for id= 1 : numel(GraphLayout.Edges.ID)
        if ~ishandle( GraphLayout.Edges.Handles(id)) 
           % draw node
           if exist('interp1','file'),
               t = linspace(0,1,size(GraphLayout.Edges.Spline{id},2)); 
               tt = linspace(0,1,1*size(GraphLayout.Edges.Spline{id},2));
               if ~any(0==diff(GraphLayout.Edges.Spline{id}(1,:)))
                   xx =  interp1(t,GraphLayout.Edges.Spline{id}(1,:),tt,'cubic');
                   yy = interp1(GraphLayout.Edges.Spline{id}(1,:),GraphLayout.Edges.Spline{id}(2,:),xx,'spline');
               elseif ~any(0==diff(GraphLayout.Edges.Spline{id}(2,:)))
                   yy =  interp1(t,GraphLayout.Edges.Spline{id}(2,:),tt,'cubic');
                   xx = interp1(GraphLayout.Edges.Spline{id}(2,:),GraphLayout.Edges.Spline{id}(1,:),yy,'spline');
               else
                   xx = GraphLayout.Edges.Spline{id}(1,:);
                   yy = GraphLayout.Edges.Spline{id}(2,:);
               end
               Dots =[xx; yy];
%                Dots =[ interp1(t,GraphLayout.Edges.Spline{id}(1,:),tt,'cubic'); interp1(t,GraphLayout.Edges.Spline{id}(2,:),tt,'cubic')];
           else
               Dots = GraphLayout.Edges.Spline{id};
           end
           GraphLayout.Edges.Handles(id) = line(Dots(1,:),Dots(2,:),'LineWidth',2);
        end
        EdgePropertiesIndex = 0;
        for i = 1 : numel(EdgeProperties)
           if isempty( EdgeProperties{i}.IDs) || any(EdgeProperties{i}.IDs==GraphLayout.Nodes.ID(id)), EdgePropertiesIndex = i; break; end
        end
        set(GraphLayout.Edges.Handles(id),'LineWidth',EdgeProperties{EdgePropertiesIndex}.LineWidth,'Color',EdgeProperties{EdgePropertiesIndex}.LineColor);
    end  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GraphLayout = PlotNodes(GraphLayout,NodeProperties)
    for id= 1 : numel(GraphLayout.Nodes.ID)
        if ~ishandle( GraphLayout.Nodes.Handles(id)) 
           % draw node
            GraphLayout.Nodes.Handles(id) = rectangle('Position',[GraphLayout.Nodes.Position(id,:)-GraphLayout.Nodes.Size(id,:)/2 GraphLayout.Nodes.Size(id,:)],'Curvature',[1 1]);
        end
        NodePropertiesIndex = 0;
        for i = 1 : numel(NodeProperties)
           if isempty( NodeProperties{i}.IDs) || any(NodeProperties{i}.IDs==GraphLayout.Nodes.ID(id)), NodePropertiesIndex = i; break; end
        end
        set(GraphLayout.Nodes.Handles(id),'LineWidth',NodeProperties{NodePropertiesIndex}.LineWidth,'EdgeColor',NodeProperties{NodePropertiesIndex}.LineColor, ...
                'FaceColor',NodeProperties{NodePropertiesIndex}.FillColor);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DefaultInput  = GetDefaultInput()
DefaultInput = {};

% DefaultInput    =   FIOAddParameter(DefaultInput,'NumberOfBins',15);
DefaultInput    =   FIOAddParameter(DefaultInput,'GraphFigureHandle',[]);
DefaultInput    =   FIOAddParameter(DefaultInput,'ShowMenuBar',false);
DefaultInput    =   FIOAddParameter(DefaultInput,'NodesOnTop',true);
DefaultInput    =   FIOAddParameter(DefaultInput,'NodeProperties',{});
DefaultInput    =   FIOAddParameter(DefaultInput,'EdgeProperties',{});

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
