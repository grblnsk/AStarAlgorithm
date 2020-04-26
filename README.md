# Matlab Implementation of A* Algorithm
#### Graph Search With Nodes in 2D Cartesian Space

#### Scripts:
* generate_random_graph.m - generates a random graph with nodes placed in finite 2D Cartesian Space
* astar_algorithm.m - searches the graph from a start node to a goal node with A* Algorithm

#### generate_random_graph.m
Inputs:
* number of nodes
* number of edges
* the maximum length of an edge

Outputs:
* graph_nodes.txt - a csv file with every node in the graph defined by a line of text of format: id, x, y.
* graph_edges.txt - a csv file with every node defined by a line of text of format: startNodeId, endNodeId, cost.

#### astar_algorithm.m
Inputs:
* graph_nodes.txt - as describe above for 'generate_random_graph.m'
* graph_edges.txt - as describe above for 'generate_random_graph.m'
* start node id - the id of the node in graph_nodes.txt that the search will start from.
* goal node id - the id of the node in graph_nodes.txt that is the goal of the search.

Outputs:
* search_tree.txt - contains search tree data, each line shows data for a node and its parent
* path.txt - contains a sequence of nodes and their positions that was found as a solution
* the last line of the script launches display_search.m (by Michael Otte) which plots the graph, the search tree, and the found path

## Example Result
![result 1](https://github.com/grblnsk/AStarAlgorithm/blob/master/other/astar_example.png?raw=true)

References:
1. Peter E. Hart, Nils J. Nilsson, Bertram Raphael - <cite>[A Formal Basis for the Heuristic Determination of Minimum Cost Paths, 1968][1]</cite>
2. Brian Moore - <cite>[Data Structures, 2020. Retrieved at MATLAB Central File Exchange on February 6, 2020.][2]</cite>
3. Michael Otte - Course: <cite>[Motion Planning for Autonomous Systems, Spring 2020][3]</cite>
 
[1]: https://ieeexplore.ieee.org/document/4082128
[2]: https://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures
[3]: http://ottelab.com/index.html
