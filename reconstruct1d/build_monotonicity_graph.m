%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD_MONOTONICITY_GRAPH 
%
% Builds a monotonicity graph based on the indices of the persistent extrema features 
% which are used to reconstruct the data.
%
% Assumes that the indices of the local minima and maxima are matched.
%
% For 1D data, a monotonicity matrix is a sparse matrix, with values != 0 
% only on two diagonals, each one 1-removed from the main diagonal.
% It is used by build_inequality_constraints to create inequality 
% constraints matrix and vector for quadprog.
%
% @params[in] mins				Indices of minima used for reconstruction
% @params[in] maxs				Indices of maxima used for reconstruction
% @params[in] global_min		Index of global minimum
% @params[in] data_length 		Length of the data vector
% @params[out] mono				Monotonicity matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Yeara !!!!!!!!!! does not handle 1-2 extrema points correctly at the moment (oops!) !!!!!!!!!!
% This needs to kinda be checked more throughly !!!!!!!!!!

function [ mono ] = build_monotonicity_graph( mins, maxs, global_min, data_length)

mins = [mins; global_min];
mins = sort(mins);
maxs = sort(maxs);

% Check if left boundary is a local minimum or a maximum
if (sum(maxs==1)==1)
    start_local_min = 0;
elseif (sum(mins==1)==1)
    start_local_min = 1;
elseif (mins(1) < maxs(1))
    start_local_min = 0;
    maxs = [1 ; maxs];
else
    start_local_min = 1;
    mins =  [1 ; mins];
end 

% Check if right boundary is a local minimum or a maximum
if (sum(maxs==data_length)~=1 && sum(mins==data_length)~=1)
    if ( mins(end) > maxs(end) ) % last extrema was min
        maxs = [maxs ; data_length];
    else %last extrema was max, add last index to min     
        mins = [mins ; data_length];
    end
end

pos_grad_vector = zeros(data_length,1);
neg_grad_vector = zeros(data_length,1);

all_ind = [mins; maxs];
all_ind = sort(all_ind);

if (start_local_min)
    for i=1:2:length(all_ind)-2
        pos_grad_vector(all_ind(i):all_ind(i+1)-1) = 1;
        neg_grad_vector(all_ind(i+1):all_ind(i+2)-1) = 1;
    end    
else 
    for i=1:2:length(all_ind)-2
    
        neg_grad_vector(all_ind(i):all_ind(i+1)-1) = 1;
        pos_grad_vector(all_ind(i+1):all_ind(i+2)-1) = 1;
    end
end

% Verify that the entire vector is full and they're the same
% size.
% if it does not divide by 2 
if (mod(length(all_ind),2) ~= 0) % odd number of indices
    if (start_local_min)  % first index is min, last index is also min
        neg_grad_vector(all_ind(length(all_ind)-1):all_ind(length(all_ind))) = 1; % max --> min
    else % first index was max, last index is also max
        pos_grad_vector(all_ind(length(all_ind)-1):all_ind(length(all_ind))) = 1; % min --> max
    end 
end

% if it divides by 2 and short - need to add 1s to the last section 
if (mod(length(all_ind),2) == 0) % even number of indices
    if (start_local_min)         % mins are at odd, maxs are at even, last index is max
        pos_grad_vector(all_ind(length(all_ind)-1):all_ind(length(all_ind))) = 1; 
    else                         % maxs are at odd, mins are at even, last index is min
        neg_grad_vector(all_ind(length(all_ind)-1):all_ind(length(all_ind))) = 1;
    end 
end

% Create lower diagonal
% Positive gradient: W(i) <= W (i+1) ==> A(i,i+1) != 0 
pos_i = 1:data_length-1;
pos_j = 2:data_length;

% Create upper diagonal
% Negative gradients: W(i+1) <= W(i) ==> A(i+1, i) != 0  
neg_i = 2:data_length;
neg_j = 1:data_length-1;  

% Ignore the last vertex? not sure if correct, but works
if (length(neg_grad_vector) == data_length)
    neg_grad_vector = neg_grad_vector(1:data_length-1);
end 

if (length(pos_grad_vector) == data_length)
    pos_grad_vector = pos_grad_vector(1:data_length-1);
end
 
% Create the sparse monotonicity matrix 
mono = sparse([pos_i neg_i], [pos_j neg_j], [pos_grad_vector neg_grad_vector], data_length, data_length);
end