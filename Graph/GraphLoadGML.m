function Graph = GraphLoadGML(FileName)
% loads graph in GML format. The format is supported by such packages as Graphlet, Pajek, yEd, LEDA, NetworkX and Gephi.
%
% Receives:
%    FileNane - string - name of the file
%
% Returns:
%   Graph - structure - graph
%
%
% Algorithm:
%   https://gephi.org/users/supported-graph-formats/gml-format/
%   Files in GML format are available at:
%       http://wiki.gephi.org/index.php/Datasets
%       http://www-personal.umich.edu/~mejn/netdata/
%
% See Also:
%   GraphLoad, GraphLoadSample, GraphSaveGML
%
% Example:
%{
   Graph = GraphLoadGML('NetworkLibrary/lesmiserables.gml');
%}
narginchk(1,1);
nargoutchk(0,1);

if ~exist(FileName,'file'), error('File ''%s'' doesn''t exist',FileName); end
Lines = LoadLines(FileName);
Graph = ParseLines(Lines); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Graph= ParseLines(Lines)
GraphIndex = find(strncmpi(Lines,'graph', numel('graph')));
if numel(GraphIndex)~=1, error('incompatible graph phormat'); end  
NodeIndex = find(strncmpi(Lines,'node', numel('node'))); NodeIndex = NodeIndex(NodeIndex>GraphIndex); 
NodeIDs = zeros( 1, numel(NodeIndex)); 
NodeNames = cell( 1, numel(NodeIndex)); 
EdgeIndex = find(strncmpi(Lines,'edge', numel('edge'))); EdgeIndex = EdgeIndex(EdgeIndex>GraphIndex); 
Edges = zeros(numel(EdgeIndex),3); 
OpenIndex = find(strncmpi(Lines,'[', numel('[')));
if isempty(OpenIndex)
    OpenIndex = find(~cellfun('isempty',strfind(Lines,'['))); 
end
CloseIndex = find(strncmpi(Lines,']', numel(']')));

for i =1 : numel(NodeIndex)     
    Start = OpenIndex(find(NodeIndex(i)<=OpenIndex,1,'first')) +1;
    End = CloseIndex(find(NodeIndex(i)<CloseIndex,1,'first')) -1;
    ID = GetLineValue(Lines(Start : End),'id'); 
    Name = GetLineValue(Lines(Start : End),'label'); 
    if ~isempty(ID), NodeIDs(i) = str2num(ID); end
    if ~isempty(Name), NodeNames{i} = Name; else NodeNames{i} = ID;  end     
end

for i =1 : numel(EdgeIndex)
    Start = OpenIndex(find(EdgeIndex(i)<=OpenIndex,1,'first')) +1;
    End = CloseIndex(find(EdgeIndex(i)<CloseIndex,1,'first')) -1;
    Source = str2num(GetLineValue(Lines(Start : End),'source')); 
    Dest = str2num(GetLineValue(Lines(Start : End),'target')); 
    Weight = GetLineValue(Lines(Start : End),'value'); 
    if ~isempty(Weight), Weight = str2num(Weight); else Weight = 1.0;  end
    Edges(i,:) = [Source Dest Weight];
end
Graph = GraphLoad(Edges, struct('IndexNames',{NodeNames},'IndexValues',{NodeIDs}),false); 
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Value = GetLineValue(Lines,Name)
    index = find(strncmpi(Lines,Name,numel(Name)));
    if ~isempty(index)
        Value = strtrim(Lines{index}(numel(Name)+1 : end));
        if numel(Value)>1 && Value(1) =='"', Value = Value(2:end); end
        if numel(Value)>1 && Value(end) =='"', Value = Value(1:end-1); end
    else
        Value = ''; 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Lines = LoadLines(FileName)
% count lines
hFile = fopen(FileName,'rt');
LinesCounter = 0;
Line = fgetl(hFile);
while ~isnumeric(Line)
    LinesCounter  = LinesCounter +1;
    Line = fgetl(hFile);
end
% load lines
Lines = cell(LinesCounter,1);
fseek(hFile,0,'bof');
LinesCounter = 0;
Line = fgetl(hFile);
while ~isnumeric(Line)
    LinesCounter  = LinesCounter +1;
    Lines{LinesCounter} = strtrim(Line);
    Line = fgetl(hFile);
end
fclose(hFile);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
