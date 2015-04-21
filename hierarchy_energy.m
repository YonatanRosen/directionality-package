function y = hierarchy_energy(g)
% Receives:	
%	g  - sparse or full matrix of binary directed graph.
% Returns: 
%	y - the hierarchy energy score.			-

% Reference:
% Carmel Liran, David Harel, and Yehuda Koren. "Combining hierarchy and energy for drawing directed graphs." Visualization and Computer Graphics, IEEE Transactions on 10.1 (2004): 46-57.

w = g + g';
w(w>1)=1;
d = diag(sum(w));
%Laplacian matrix
l = d - w;
id = sum(g,1);    
od = sum(g,2)'; 
b = od' - id';
tol = 0.001;
n = size(g,1);
y = rand(n,1);
y = y - (1/n)*sum(y);
r = b-l*y; d = r;

while norm(r) > tol
    gamma = r'*r;
    alpha = gamma/(d'*l*d);
    y = y + alpha*d;
    r = r-alpha*l*d;
    beta = (r'*r)/gamma;
    d = r+beta*d;
end
     
end

