%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP_PERSISTENCE1D
%
% Run this script from %Reconstruct1d% directory. 
% Adds current directory and Persistence1D Matlab directory to Matlab's path. 
% If run_persistence1d does not exist as a mex file, it tries to  
% compile it. This only works if the user's mex compiler is configured.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = setup_persistence1d()
    addpath('..\matlab');
	addpath('.');
    if (exist('run_persistence1d')~=3)
        cd '..\matlab'
        mex run_persistence1d.cpp
        cd '..\reconstruct1d'
    end
end