%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TURN_ON_MOSEK
% 
% Adds MOSEK directories the Matlab's path.
% MOSEK optimizers automatically override Matlab's optimizers, any subsequent
% calls to optimizers will be solved by MOSEK. 
%  
% Before first use, comment out the unnecessary lines, according to MOSEK
% installation directory (see MOSEK documentation).
%
% To turn off MOSEK optmizers, Use turn_off_mosek.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = turn_on_mosek()
	addpath 'c:\Program Files\mosek\7\toolbox\r2009b';
	% addpath 'c:\Program Files\mosek\7\toolbox\r2012a'; 
	% addpath 'c:\Program Files\mosek\7\toolbox\r2013a';
end