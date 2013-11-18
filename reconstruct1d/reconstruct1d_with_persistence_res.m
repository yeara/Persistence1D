%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCT1D_WITH_PERSISTENCE_RES
% 
% This function is called by Recosntruct1D to do the actual reconstruction 
% after it finished running Persistence1D.
% Users can call this function directly with Persistence1D results if such
% are already available. 
%
% This function reconstructs a smooth function which approximates the input data, 
% based on persistent features. 
%
% Adherence to the original data is controlled using 
% the 'data_weight' term. 
%
% Reconstructed function can be C1 or C2 smooth, set the 
% smoothness parameter to 'biharmonic' or 'triharmonic' accordingly.
%
% All extrema sent to the function are used for reconstruction.
% Filter unwanted extrema points before using this function using
% filter_features_by_persistence from Persistence1D class.
%
% @param[in] data						Original data vector.
% @param[in] min_indices				Indices of persistent minima for reconstruction. 
% @param[in] max_indices				Indices of persistent maxima for reconstruction. 
% @param[in] global_min					Index of global minimum
% @param[in] smoothness					Valid values - 'biharmonic' or 'triharmonic'
% @param[in] data_weight				Weight for data term. Affects how closely the 
%										reconstructed results adhere to the data.
%										Recommended value: around 10^-6. 
%										Valid range: 0.0-1.0
% @param[out] x  						Reconstructed data. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x]  = reconstruct1d_with_persistence_res( data, ...
													min_indices, ...
													max_indices, ...
													global_min, ...
													smoothness, ...
													data_weight)

    % Verify smoothness type is valid
    if (strcmp(smoothness,'biharmonic')~= 0 && strcmp(smoothness,'triharmonic')~= 0)
        fprint('unrecognized interpolation type: choose biharmonic or triharmonic');
        return;
    end 
    
	% Verify data weight is valid
    if  (data_weight < 0.0 || data_weight > 1.0)
        fprint('data term weight must be <= 1.0 and >= 0.0');
        return;
    end 
    
	if (size(data,1) ~= 1)
        data = data';
    end
	
    % Build equality constraints
    [Aeq beq] = build_equality_constraints(min_indices, max_indices, global_min, data);
    
    % Build inequality constraints
    mon_graph = build_monotonicity_graph(min_indices, max_indices, global_min, length(data));
    A = build_inequality_constraints(mon_graph);
    b = zeros(1, size(A,1)); 
    
    % Build the discrete Laplacian operator, a basis for the biharmonic or triharmonic smoothness operator
    lapacian = build_laplacian(length(data));
    
    switch smoothness 
        case 'biharmonic'
            operator = lapacian * lapacian;
        case 'triharmonic'
            operator = lapacian * lapacian * lapacian;
            operator =  (operator + operator') * 0.5;
        otherwise
            disp('Unrecognized interpolation type. Use '' or ''');
			return;
    end
    
    f = zeros(length(data),1);
    
    % Add data term weight to diagonal
    if (data_weight ~= 0)

        data_weight_rep = repmat(data_weight,length(data),1);
        
        operator = operator + 2 * diag(sparse(data_weight_rep));

        f = -2 * data_weight  * data';
    end
   
	
	x = quadprog(operator,f,A,b,Aeq,beq);
    
end