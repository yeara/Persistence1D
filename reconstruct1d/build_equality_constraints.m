%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD_EQUALITY_CONSTRAINTS 
%
% Creates the equality constraints matrix and vector for quadprog. 
% Constrained vertices include - all persistence features (their paired minima and
% maxima), the global minimum and the domain edges. The reconstructed function
% is guarnteed to preserve their location and their value - no new minima or maxima are
% created.
% 
% @param[in] mins				Minima used for reconstruction
% @param[in] maxs				Maxima used for reconstruction
% @param[in] globalMinIndex		Index of global minimum. Will be used for
%                               reconstruction.
% @param[in] data				Original data vector
% @param[out] A					A sparse n x m matrix, where m = length(data) and m = 2 x number of 
%								persistence pairs + 1 + # unconstrained domain edges. Non zero entries
%								are only for constrained vertices.
% @param[out] Aeq				m x 1 vector which contains the data values at the constrained points. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A Aeq] = build_equality_constraints(mins, maxs, globalMinIndex, data)

idx = [mins; maxs; globalMinIndex];
idx = sort(idx); 

rows = size(idx, 1);
cols = length(data);

add_left_edge = 0;  
add_right_edge = 0;

%if the left edge is constrained 
if (sum(idx==1) ~= 1)
   add_left_edge = 1; 
   idx = [1 ; idx];
end

if (sum(idx==cols) ~= 1)
    add_right_edge = 1;
    idx = [idx ; length(data)];
end 

irows = 1:length(idx);

%general sparse matrix syntax - sparse(i,j,s,m,n)
A = sparse(double(irows), double(idx), double(ones(length(idx),1)), (rows + add_right_edge + add_left_edge), (cols));

Aeq(irows) = data(idx);
Aeq = Aeq';

end