%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCT1D_BASIC_EXAMPLE
%
% Basic example for Reconstruct1D usage.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add Reconstruct1D folder to Matlab's path
addpath('..');

% Setup Persistence1D and MOSEK
setup_persistence1d();
turn_on_mosek();

% Load the data set
load '..\datasets\test_data.mat';

% Choose smoothness for the reconstructed function. 
% 'biharmonic' smoothness guarantees that the reconstructed function is C1 smooth
% 'triharmonic' smoothness guarantees that the reconstructed function is C2 smooth
smoothness = 'biharmonic';

% Choose a threshold for persistence features
threshold = 0.2;

% The data term weight affects how closely the reconstructed function 
% adheres to the data.
data_weight = 0.0000001;

x = reconstruct1d(data, threshold, smoothness, data_weight);
plot_reconstructed_data(data, x, smoothness, threshold, data_weight);
turn_off_mosek();