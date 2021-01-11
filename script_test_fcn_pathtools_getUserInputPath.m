% script_test_fcn_pathtools_getUserInputPath
% This is a script to exercise the function:
% fcn_pathtools_getUserInputPath.m
% This function was written on 2020_10_15 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revisions
%     2020_10_15
%     -- First write of the code
%     2021_01_15
%     -- Modified to make the code reentrant for stand-alone operation


close all;

%% BASIC example 1
fig_num = 1;
h = figure(fig_num);
hold on;

num_iterations = input('How many paths do you want to draw? [Hit enter for default of 3]:','s');
if isempty(num_iterations)
    num_iterations = 3;
end

% Initialize the paths_array
paths_array{num_iterations} = [0 0];  
for i_path = 1:num_iterations

    % Set the title header
    UserData.title_header = sprintf('Path %.0d of %.0d',i_path,num_iterations);
    
    % Save the results
    set(gcf,'UserData',UserData);
    
    pathXY = fcn_pathtools_getUserInputPath(fig_num);
    paths_array{i_path} = pathXY;
end


% % Convert paths to traversal structures
% for i_Path = 1:length(paths_array)
%     traversal = fcn_Path_convertPathToTraversalStructure(paths_array{i_Path});
%     data.traversal{i_Path} = traversal;
% end
% 
% % Plot the results
% fig_num = 12;
% fcn_Path_plotTraversalsYaw(data,fig_num);
% fig_num = 13;
% fcn_Path_plotTraversalsXY(data,fig_num);

