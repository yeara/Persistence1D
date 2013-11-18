%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT_RECONSTRUCTED_DATA 
%
% Creates a new figure with a plot of the original data, the reconstructed data, 
% and the constrained vertices. 
% Adds an informative title for the plot and a legend. 
%
% @param[in] data 					Original data vector
% @param[in] reconstructed_data		Reconstructed data vector
% @param[in] smoothness				Guaranteed smoothness of reconstruction. Only used for title.
% @param[in] threshold				Persistence threshold. Only used for title.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plot_reconstructed_data(data, reconstructed_data, smoothness, threshold, data_weight)
    figure;
    plot_title = get_plot_title(smoothness, threshold, data_weight);
    plot(data, 'LineWidth', 2); 
    hold on;
    title(plot_title);
    plot(reconstructed_data,'magenta', 'LineWidth', 2);
    legend('data', [smoothness, ' reconstruction' ]);
    hold off;
end

function [plot_title] = get_plot_title(smoothness, threshold, data_weight)
    plot_title = strcat(smoothness,' interpolation, persistence threshold ', num2str(threshold), ' data term weight ', num2str(data_weight));
end