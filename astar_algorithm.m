% MIT License
% 
% Copyright (c) 2020 Jacek Garbulinski
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% Implementation of A* Algorithm

% Uses MinHeap, Heap classes from Data Structures Repository at:
% https://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures
% by Brian Moore
% *I modified the heap class to take [key value] pairs
% instead of only a numeric key.

% Uses display_search.m by Michael Otte

clear;
%% INPUTS
startNodeId = 1;
goalNodeId = 25;

%% FLAGS AND COLUMNS
VISITED = 0;
UNVISITED = 1;
% ND matrix column mapping
ID = 1;
POSX = 2;
POSY = 3;
STATUS = 4;
PARENT = 5;
COST2START = 6;

%% LOAD DATA
% Load nodes' data CSV: id, x, y
nodesFilename = ['graph_nodes.txt'];
NodesData = dlmread(nodesFilename,',',1,0);
numberOfNodes = size(NodesData,1);
% Load edges' data CSV: start_node_id, end_node_id, cost
edgesFilename = ['graph_edges.txt'];
EdgesData = dlmread(edgesFilename,',',1,0);
numberOfEdges = size(EdgesData,1);
% Create matrix representation of connections
EdgeMatrix = zeros( numberOfNodes, numberOfNodes );
for k = 1:numberOfEdges
    startId = EdgesData(k,1);
    endId = EdgesData(k,2);
    cost = EdgesData(k,3);
    EdgeMatrix( startId, endId ) = cost;
end

%% DEFINE DATA OPERATIONS
% Define functions to determine parents and children
% here, equivalent of incoming and outcoming edges
% EdgeMatrix
getParents = @(nodeId) find(EdgeMatrix(nodeId,:));
getChildren = @(nodeId) find(EdgeMatrix(:,nodeId));
getNumberOfChildren = @(nodeId) length(getChildren(nodeId));
getCost = @(startNodeId, endNodeId) EdgeMatrix(startNodeId, endNodeId);
% NodesData Related
getX = @(nodeId, nodesData) nodesData(nodeId, 2);
getY = @(nodeId, nodesData) nodesData(nodeId, 3);
getXY = @(nodeId, nodesData) [getX(nodeId, nodesData) getY(nodeId, nodesData)];
getStatus = @(nodeId, nodesData) nodesData(nodeId, STATUS);
getCostToStart = @(nodeId, nodesData) nodesData(nodeId, COST2START);

%% Admissible Heuristic Function
getHCost = @(nodeId, nodesData)...
    norm(getXY(nodeId,nodesData)-getXY(goalNodeId,nodesData),2);

%% RUN SEARCH
% Create ND to preserve original NodesData
ND = NodesData;
% Add column to store status
ND = [ND ones(numberOfNodes,1)];
% Add column to store parent
ND = [ND zeros(numberOfNodes,1)];
% Add column to store cost to start
ND = [ND ones(numberOfNodes,1)*Inf];

% Initialize startNode
ND(startNodeId,STATUS) = 0;
ND(startNodeId,COST2START) = 0;
Q = MinHeap(numberOfNodes,[startNodeId getCostToStart(startNodeId, ND)]);
Q.ReturnMin();
goalFound = false;

while Q.Count() ~= 0
    v = Q.ExtractMinKey();
    getCostToStart(v, ND);
    vChildren = getChildren(v);
    for k=1:getNumberOfChildren(v)
        u = vChildren(k);
        if ( (ND(u,STATUS) == UNVISITED) || ...
                (  getCostToStart(u, ND) > getCostToStart(v, ND) + getCost(v,u) ) )
            ND(u,STATUS) = VISITED;
            ND(u,PARENT) = v;
            ND(u,COST2START) = getCostToStart(v, ND) + getCost(v,u);
            Q.InsertNode([u getCostToStart(u, ND) + getHCost(u,ND)]);
        end
    end
    if v == goalNodeId
        goalFound = true;
        break;
    end 
end

%% SEARCH TREE
SearchTreeNodes = zeros(numberOfNodes, 6);
SearchTreeNodes(1,:) = [NodesData(startNodeId,:) NodesData(startNodeId,:)];
for k = 1:numberOfNodes
    if ND(k,PARENT)~=0
        SearchTreeNodes(k,:) = [NodesData(k,:) NodesData(ND(k,PARENT),:)];
    end
end
% Filter out zeros
SearchTreeNodes = SearchTreeNodes(SearchTreeNodes(:,ID) ~= 0, :);
% Save search tree to file
csvwrite(['search_tree.txt'],SearchTreeNodes)

%% THROW ERROR IF GOAL NODE WAS NOT FOUND
if ~goalFound
    ME = MException('Goal Node Not Found', ...
        'Goal not was not found');
    throw(ME)
end

%% PATH RECONSTRUCTION
tempNodeId = goalNodeId;
Path = zeros(numberOfNodes, 1);
iter = 1;
while tempNodeId ~= startNodeId
        Path(iter) = tempNodeId;
        tempNodeId = ND(tempNodeId,PARENT);
        iter = iter +1;
end
Path(iter) = startNodeId;
% Filter zeros and flip the order of node ids
Path = flip( Path(Path ~= 0) );
% Use node ids to get their id, x, y data
PathNodes = NodesData(Path,:);
% Save path to file
csvwrite(['path.txt'],PathNodes)

csvwrite(['start_and_goal.txt'],[startNodeId goalNodeId]);

display_search
