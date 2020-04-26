% Copyright 2018, Michael Otte
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

% Modified by Jacek Garbulinski, April 2020

% displays the search tree and path
% assuming that the files have been generated

clear;
% Algorithm variable is only use for the title of the plot! 
% It won't change the data stored in the files
algorithm = 'A*';
% Problem Number for file acces

search_tree_raw = csvread(['search_tree.txt']);
path_raw = csvread(['path.txt']);
nodes_raw = csvread(['graph_nodes.txt']);
edges_raw = csvread(['graph_edges.txt']);
startgoal = csvread(['start_and_goal.txt']);
startNodeId = startgoal(1,1);
goalNodeId = startgoal(1,2);
% a bit of data processing for faster plotting
search_tree = nan(3*size(search_tree_raw, 1), 2);

search_tree(1:3:end-2, 1) = search_tree_raw(:, 2);
search_tree(2:3:end-1, 1) = search_tree_raw(:, 5);
search_tree(1:3:end-2, 2) = search_tree_raw(:, 3);
search_tree(2:3:end-1, 2) = search_tree_raw(:, 6);

nodes = nodes_raw(2:end,2:3);

edges_raw = edges_raw(2:end,:);

edges = nan(3*size(edges_raw, 1), 2);

edges(1:3:end-2, 1) = nodes(edges_raw(:, 1),1);
edges(2:3:end-1, 1) = nodes(edges_raw(:, 2),1);
edges(1:3:end-2, 2) = nodes(edges_raw(:, 1),2);
edges(2:3:end-1, 2) = nodes(edges_raw(:, 2),2);

figure(1)
plot(nodes(:,1), nodes(:,2), 'ok')
hold on
plot(edges(:,1), edges(:,2), 'k')
plot(search_tree(:, 1), search_tree(:, 2), 'm', 'LineWidth', 2);
plot(path_raw(:,2), path_raw(:,3), 'g:', 'LineWidth', 3);

scatter(nodes(startNodeId,1),nodes(startNodeId,2),'gx','LineWidth',15)
scatter(nodes(goalNodeId,1),nodes(goalNodeId,2),'rx','LineWidth',15)
hold off

% Add title and save
title([algorithm])
% saveas(gcf,[algorithm '_Problem_' num2str(1) '.png'])


