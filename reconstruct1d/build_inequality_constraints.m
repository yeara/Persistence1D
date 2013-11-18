%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD_INEQUALITY_CONSTRAINTS 
%
% Converts adjacency matrix graphs into
% linear inequality constraints to use with Matlab's quadprog. 
% Inequality constraints are used to localize the local extrema 
% created in the interpolation process.
%
% The inequality constraints are as follows: 
%
% For each vertex which is not a minimum nor a maximum, it will have 
% one neighbor smaller than itself and one neighbor greater than itself. 
% Local minima are constrained to be smaller than both of their neighbors. 
% Local maxima are constrained to be greater than both of their neighbors. 
% Within each component between a local minimum and a local maximum, monotonicity
% is guaranteed. 
%
% @params[in] A			data length x data length monotonicity graph 
%						(sparse adjacency matrix) with A{k}(i,j) !=
%    					0 if we want that W(i,k) <= W(j,k) 
% @params[out] Aleq  	list of inequality constraints derived from A
%
% Code is adapted from Alec Jacobson, 2011 (jacobson@inf.ethz.ch)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Aleq] = build_inequality_constraints(A)
  
  assert(~isempty(A));
  n = size(A,1);

  [AI,AJ,AV] = find(A);
  nleq = size(AI,1);
  Aleq = ...
    sparse([1:nleq 1:nleq]',[AI;AJ],[ones(nleq,1);-ones(nleq,1)],nleq,n);
    
    if (size(Aleq,1) < size(Aleq,2))
        % Aleq has more 
        Aleq = [Aleq ; zeros(size(Aleq,2) - size(Aleq,1), size(Aleq,2))];
    elseif (size(Aleq,1) > size(Aleq,2))
        Aleq = [Aleq  zeros(size(Aleq,1), size(Aleq,1) - size(Aleq,2))];
    end 
end
