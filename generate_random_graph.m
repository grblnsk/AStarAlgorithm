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

% GENERATE RANDOM 2D GRAPH AND SAVE TO TEXT
clear;
numNodes = 100;
numEdges = 10000;
edgeMaxLength = 15;
%node: id, x, y
nodes = zeros(numNodes,3);
%edge: start-node-id, end-node-id, cost(here, cartesian-distance)
edges = zeros(numEdges,3);

%define workspace
x1 = 0;
x2 = 100;
y1 = 0;
y2 = 100;
rangeX = x2-x1;
rangeY = y2-y1;

%rand to x, y, id
randX = @() rand()*rangeX+x1;
randY = @() rand()*rangeY+y1;
randId = @() ceil(rand()*numNodes);

for k=1:numNodes
    nodes(k,:) = [k randX() randY()];
end

for k=1:numEdges
    do = true;
    while(do)
        n1 = randId();
        n2 = randId();
        ndist = norm( nodes(n2,2:3)-nodes(n1,2:3));
        edges(k,:) = [n1 n2 ndist];
        do = ndist>=edgeMaxLength;
    end
end
dlmwrite(['graph_nodes.txt'],numNodes);
dlmwrite(['graph_nodes.txt'],nodes,'-append','delimiter',',','precision',4);
dlmwrite(['graph_edges.txt'],numEdges);
dlmwrite(['graph_edges.txt'],edges,'-append','delimiter',',','precision',4);



