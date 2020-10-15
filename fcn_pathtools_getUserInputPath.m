function pathXY = fcn_pathtools_getUserInputPath(varargin)
% fcn_pathtools_getUserInputPath
% A function for the user to click on the figure to generate XY path until
% the user hits the "return" key.
%
% FORMAT: 
%
%      pathXY = fcn_pathtools_getUserInputPath
%
% INPUTS:
%
%      (optional) figure_number: an integer specifying which figure to use 
%
% OUTPUTS:
%      pathXY: matrix (Nx2) representing the X and Y points that the user
%      clicked on the map
%
% EXAMPLES:
%      
%      % BASIC example
%      pathXY = fcn_pathtools_getUserInputPath
% 
% See the script: script_test_fcn_pathtools_getUserInputPath
% for a full test suite.
%
% This function was written on 2020_10_15 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2020_10_15 - wrote the code


flag_do_debug = 0; % Flag to plot the results for debugging
flag_make_figure = 0;
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    flag_make_figure = 1;
    fprintf(1,'Starting function: %s, in file: %s\n',st(1).name,st(1).file);
end

%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_| 
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Are the input vectors the right shape?
% Npoints = length(points(:,1));

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 0 || nargin > 1
        error('Incorrect number of input arguments')
    end
    
    %     if Npoints<2
    %         error('The points vector must have at least 2 rows, with each row representing a different (x y) point');
    %     end
    %     if length(points(1,:))~=2
    %         error('The points vector must have 2 columns, with column 1 representing the x portions of the points, column 2 representing the y portions.');
    %     end
end

% Does user want to show the plots?
if 1 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_make_figure = 1;
else
    if flag_do_debug
        fig = figure; 
        fig_num = fig.Number;
    end
end

%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up the figure
figure(fig_num);
axis([0 100 0 100]);
title('Click out a path onto the given figure. Hit return when done.');

% Get a set of starting points
[X1,Y1] = ginput;
pathXY = [X1 Y1];



%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _                 
%  |  __ \     | |                
%  | |  | | ___| |__  _   _  __ _ 
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_make_figure
    figure(fig_num);
    hold on;
    grid on;
    plot(pathXY(:,1),pathXY(:,2),'r.','Markersize',20);
    plot(pathXY(:,1),pathXY(:,2),'r-','Linewidth',3);
       
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); %#ok<NODEF>
end
end







