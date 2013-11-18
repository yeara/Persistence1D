%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD_LAPLACIAN 
% 
% Creates a discrete Laplacian operator matrix
% for uniformly spaced 1D data. 
%
% @param[in]  len          	Length of the data vector to be reconstructed.  
% @param[out] laplacian		Discrete Laplacian operator matrix for the data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [laplacian] = build_laplacian(len)

%create diagonal vector
i = 1:len-1;
j = 1:len-1;
val = ones(1,len-1) * -1;    

% create above diagonal vector
row = 1:len-1;
col = 2:len;
val_above_diagonal = ones(1, len-1);

grad = sparse([i row], [j col], [val val_above_diagonal], len, len);

laplacian = grad' * grad;    

end