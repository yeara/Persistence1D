%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCT1D 
%
% Reconstruct smooth functions from noisy data, based on persistent features. 
% This is an addon to Persistence1D class.
%
% This function reconstructs a smooth function which approximates the input data, 
% based on persistent features. Persistence1D is called and run each time this 
% function is called. 
%
% The threshold for persistent features is called by 'threshold' parameter.
%
% Adherence to the original data is controlled using 
% the 'data_weight' term. 
%
% Reconstructed function can be C1 or C2 smooth, set the 
% smoothness parameter to 'biharmonic' or 'triharmonic' accordingly.
% 
% @param[in] data						Original data vector
% @param[in] threshold					Threshold for features to use for interpolation
% @param[in] smoothness					Valid values - 'biharmonic' or 'triharmonic'
% @param[in] data_weight				Weight for data term. Affects how closely the 
%										reconstructed results adhere to the data.
%										Recommended value: around 10^-6. (This varies with
%										the dataset)
%										Valid range: 0.0-1.0
% @param[out] x							Reconstructed data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x]  = reconstruct1d(data, threshold, smoothness, data_weight)

    % Verify interpolation type is valid
    if (strcmp(smoothness,'biharmonic')~= 0 && strcmp(smoothness,'triharmonic')~= 0)
        fprint('unrecognized smoothness type: choose ''biharmonic'' or ''triharmonic''');
        return;
    end 
    
	% Verify data weight is valid
    if  (data_weight < 0.0 || data_weight > 1.0)
        fprint('data term weight must be <= 1.0 and >= 0.0');
        return;
    end 
    
    % Input should be in SINGLE precision
    single_precision_data = single(data);

    % Run persistence
    [min_indices max_indices persistence global_min_index global_min_val] = run_persistence1d(single_precision_data); 
    
    filtered_pairs = filter_features_by_persistence(min_indices, max_indices, persistence, threshold);
        
	min_indices = get_min_indices(filtered_pairs);
	max_indices = get_max_indices(filtered_pairs);
	
    % Call resconstruct1d with all prepared data
	x = reconstruct1d_with_persistence_res( data, min_indices, max_indices, global_min_index, smoothness, data_weight);
											
end