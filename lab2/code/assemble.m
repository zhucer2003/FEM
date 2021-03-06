function [A,R,b,r] = assemble(p,e,t,f,k,g)
	N = size(p,2); 																					% number of nodes
	A = sparse(N,N);
	R = sparse(N,N);
	b = zeros(N,1);
	r = zeros(N,1);
	for K = 1:size(t,2);
		  nodes = t(1:3,K);                                   % node numbers for triangle K
		  x = p(1,nodes); y = p(2,nodes);                     % node coordinates
		  area = polyarea(x,y);                               % triangle area
		  b_ = [y(2)-y(3); y(3)-y(1); y(1)-y(2)]/2/area;      % hat function gradients (N.B. factor 2*area)
		  c_ = [x(3)-x(2); x(1)-x(3); x(2)-x(1)]/2/area;
		  AK = (b_*b_'+c_*c_')*area;                          % element stiffness matrix
		  bK = [2 1 1; 1 2 1; 1 1 2]*area/12*f(x,y)'; 				% element load vector
		  A(nodes,nodes) = A(nodes,nodes) + AK;        				% add element contributions to A and b
		  b(nodes) = b(nodes) + bK;
	end

	for E = 1:size(e,2)
		  nodes = e(1:2,E); 																	% node numbers of boundary edge E
		  x = p(1,nodes); y = p(2,nodes);
		  ds = sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
		  k_ = k(mean(x),mean(y));
		  g_ = g(mean(x),mean(y));
		  R(nodes,nodes) = R(nodes,nodes) + k_*[2 1; 1 2]*ds/6;
		  r(nodes) = r(nodes) + k_*g_*[1; 1]*ds/2;
	end
end
