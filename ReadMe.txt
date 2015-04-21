Network's directionality package
================================
Directed acyclic graphs have clear order, where precedence relations among vertices are
naturally defined. Many directed real world networks contain inherent order that may be masked by
strong connectivity components or long circles. Two algorithms aim at uncover the inherent order in directed
networks that contain cycles as well.
This package contains implementation of algorithms that handle the directionality problem. The two algorithms 
receive a binary directed graph and return a centrality score where high score vertices precede lower score
vertices in the graph hierarchy.
The flow algorithm exploits the asymmetry in distances in the directed graph and its underlying undirected
graph. The hierarchy energy algorithm minimizes an energy function that takes into consideration all ordered
relations of unidirectional edges.

To view example code run example.m .

The flow algorithm uses mex files that run on windows only.
The hierarchy energy algorithm has no operation system limitations.

flow reference:
Yonatan Rosen and Yoram Louzoun, "Directionality of real world networks as predicted by path length in directed and undirected graphs." Physica A: Statistical Mechanics and its Applications 401 (2014): 118-129.
hierarchy energy reference:
Carmel Liran, David Harel, and Yehuda Koren. "Combining hierarchy and energy for drawing directed graphs." Visualization and Computer Graphics, IEEE Transactions on 10.1 (2004): 46-57.

Yoram Louzoun's lab: http://peptibase.cs.biu.ac.il/

The package includes the BFS function of Lev Muchnik's complex networks toolbox:
http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html

