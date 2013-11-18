%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCT1D_DATA_WEIGHTS
%
% This example demonstrates how the data term weight affects the 
% results of Reconstruct1D. 
% For data weight = 1.0 results will be almost exactly the  data vector.
% Data term weights of around 10^-6 reconstruct smoother functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Add the parent directory to path, it includes all Reconstruct1D 
% Matlab scripts
addpath('..');

% Setting up Persistence1D and MOSEK optimizers
setup_persistence1d();
turn_on_mosek();

% Load example data
load '..\datasets\data_weights_set.mat';
data = sample_data;
single_precision_data = single(data);
smoothness = 'biharmonic';
threshold = 0.2;

% Run Persistence1D
[minIndices maxIndices persistence globalMinIndex globalMinValue] = run_persistence1d(single_precision_data);

% Choose persistence features for reconstruction
filtered_pairs = filter_features_by_persistence(minIndices, maxIndices, persistence, threshold);
min_indices = get_min_indices(filtered_pairs);
max_indices = get_max_indices(filtered_pairs);

% Create data term weights
weights_1st_fig = [1.0, 0.1, 0.01 ];
weights_2nd_fig = [10^-4, 10^-4,  0 ];

colors = {'red', 'green', 'magenta', 'cyan', 'yellow'};

% Creates two figures with plots of the different reconstructions
for j=1:2
    
    if (j==1)
        weights = weights_1st_fig;
    else
        weights = weights_2nd_fig;
    end
    
    figure;
    plot(data, 'blue', 'LineWidth', 2);
    title('biharmonic reconstruction');

    hold on;

    titles{1} = 'original data';

    for i=1:length(weights)
        data_weight = weights(i);
		
		% Call Reconstruct1D with Persistence1D results
        x = reconstruct1d_with_persistence_res ( data, min_indices, max_indices, globalMinIndex, smoothness, data_weight);
        plot(x, colors{i}, 'LineWidth', 2 );
        titles{i+1,1} = ['data weight = ', num2str(weights(i))];
    end

    legend(titles{1:1+length(weights)});
    hold off; 
    
    titles = [];

end

turn_off_mosek();