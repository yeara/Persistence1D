%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT_RECONSTRUCTED_DATA_WITH_EQUALITY_CONSTRAINTS
%
% Creates a new figure with a plot of the original data, the reconstructed data, 
% and the constrained vertices. 
% Adds an informative title for the plot and a legend. 
%
% @param[in] data 					Original data vector
% @param[in] reconstructed_data		Reconstructed data vector
% @param[in] Aeq					Equality constraints matrix
% @param[in] beq					Equality constraints vector
% @param[in] smoothness				Name of interpolation type
% @param[in] threshold				Persistence threshold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plot_reconstructed_data_with_equality_constraints(data, reconstructed_data, Aeq, beq, smoothness, threshold, data_weight)
    figure;
    plot_title = get_plot_title(smoothness, threshold, data_weight);
    plot(data); 
    hold on;
    title(plot_title);
    scatter(Aeq * (1:length(data))', beq, 'green');
    plot(reconstructed_data,'magenta');
    legend('data', 'constraints', smoothness );
    hold off;
end

function [plot_title] = get_plot_title(smoothness, threshold, data_weight)
    plot_title = strcat(smoothness,' interpolation, persistence threshold  ', num2str(threshold), ' data term weight  ', num2str(data_weight));
end