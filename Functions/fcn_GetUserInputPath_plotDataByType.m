function hPoints = fcn_GetUserInputPath_plotDataByType(data, varargin)
% fcn_GetUserInputPath_plotDataByType
%
% A function for plotting data defined by different drawing/input styles
%
% FORMAT:
%
%      hPoints = fcn_GetUserInputPath_plotDataByType(data,(inputType),(figNum))
% 
% 
% INPUTS:
%
%      data - initial XY or LatLon points to use.
%
%      (OPTIONAL INPUTS)
%
%      inputType - string specifying the drawing/input style. Options are:
%
%         'path'   - default behavior. The user-selected points are
%         displayed asconnected line segments.
%      
%         'points' - the user-selected points are displayed as individual
%         points without connecting line segments.
%      
%         'patch'  - the user-selected points are displayed as a closed
%         patch. When at least 3 valid points are available, the patch is
%         drawn by connecting the selected points in order. If fewer than 3
%         valid points are available, the input is displayed like a path so
%         the user can still see the selected points.
%      
%         'aabb'   - the user selects two opposite corners, and the
%         function returns the axis-aligned bounding box defined by those
%         points. This mode is intended to define one AABB per function
%         call. If additional points are selected, the second corner is
%         updated rather than creating multiple boxes.
%       
%         'directedpath' - the user-selected points are displayed as a
%         directed path using arrows between consecutive points.
%      
%         'onesidedsegment' - the user selects two points defining a
%         segment. A small perpendicular arrow is drawn at the midpoint to
%         indicate the positive/visible side of the segment. The positive
%         side is the left side when moving from the start point to the end
%         point.
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      hPoints - a handle to the plot of the points
% 
%  EXAMPLES:
%
% See the script: script_test_fcn_GetUserInputPath_plotDataByType
% for a full test suite.
%
% This function was written on 2026_06_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: fcn_GetUserInputPath_plotDataByType
%
% 2026_06_08 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_plotDataByType
%   % * Made this function starting with fcn_GetUserInputPath_ + plotDataByType
%

% TO-DO:
% - 2026_06_08 by Sean Brennan, sbrennan@psu.edu
%   % - Add to-do items here


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 3; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
	flag_do_debug = 0; % Flag to plot the results for debugging
	flag_check_inputs = 0; % Flag to perform input checking
	flag_max_speed = 1;
else
	% Check to see if we are externally setting debug mode to be "on"
	flag_do_debug = 0; % Flag to plot the results for debugging
	flag_check_inputs = 1; % Flag to perform input checking
	MATLABFLAG_GETUSERINPUTPATH_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_GETUSERINPUTPATH_FLAG_CHECK_INPUTS");
	MATLABFLAG_GETUSERINPUTPATH_FLAG_DO_DEBUG = getenv("MATLABFLAG_GETUSERINPUTPATH_FLAG_DO_DEBUG");
	if ~isempty(MATLABFLAG_GETUSERINPUTPATH_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_GETUSERINPUTPATH_FLAG_DO_DEBUG)
		flag_do_debug = str2double(MATLABFLAG_GETUSERINPUTPATH_FLAG_DO_DEBUG);
		flag_check_inputs  = str2double(MATLABFLAG_GETUSERINPUTPATH_FLAG_CHECK_INPUTS);
	end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
	st = dbstack; %#ok<*UNRCH>
	fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
	debug_figNum = 999978; %#ok<NASGU>
else
	debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
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
if 0==flag_max_speed
	if flag_check_inputs
		% Are there the right number of inputs?
		narginchk(1,MAX_NARGIN);

		% validateattributes(L,{'numeric'},{'scalar','positive'});
		% validateattributes(W,{'numeric'},{'scalar','positive'});

	end
end

% Does the user want to specify the input type?
% Options:
%   'path'   - default, connected line segments
%   'points' - points only, no lines
%   'patch'  - closed polygon/patch
%   'aabb'   - axis aligned bounding box from two selected corners
%   'directedpath' - a path using arrows between consecutive points.
%   'onesidedsegment' - a segment with arrow showing which side is visible

inputType = 'path'; % default
if 2 <= nargin
	temp = varargin{1};
	if ~isempty(temp)
		inputType = lower(temp);
	end
end


% Does user want to specify the figure number?
flag_do_plots = 1; % Default is to show plots
figNum = [];
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp;
    end
end

if isempty(figNum)
	temp = figure;
	figNum = get(temp,'Number');
end


validInputTypes = {'path','points','patch', 'aabb','directedpath','onesidedsegment'};
if ~any(strcmp(inputType,validInputTypes))
	error('inputType must be one of: path, points, patch, aabb, directedpath, onesidedsegment');
end

%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(figNum);

% For debugging
warning('backtrace','on');

ax = gca;
flag_isGeoPlot = isa(ax,'matlab.graphics.axis.GeographicAxes');
hold(ax, 'on')

if isempty(data)
	data = [nan nan];
end

% Create the user input drawing object
switch inputType
	case 'path'
		if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected path');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected path');
		end

	case 'points'
		if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.', ...
				'MarkerSize',20, ...
				'DisplayName','User selected points');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.', ...
				'MarkerSize',20, ...
				'DisplayName','User selected points');
		end

	case 'patch'
		if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected patch');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected patch');
		end

	case 'aabb'
	       if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected aabb');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected aabb');
        end

    case 'directedpath'
		if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected directed path');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected directed path');
		end

	case 'onesidedsegment'
		if flag_isGeoPlot
			hPoints = geoplot(ax, data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected one-sided segment');
		else
			hPoints = plot(data(:,1), data(:,2), ...
				'r.-', ...
				'MarkerFaceColor','r', ...
				'DisplayName','User selected one-sided segment');
		end

		otherwise
		error('Unknown inputType. Use path, points, patch, aabb, directedpath, or onesidedsegment.');
end

if isempty(hPoints) || ~isgraphics(hPoints)
	error('hPoints was not created. Check inputType and drawing object creation.');
end

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

if flag_do_plots
	% Nothing to do

end

if flag_do_debug
	fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end
end




%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_INTERNAL_updateDrawing
function fcn_INTERNAL_updateDrawing(pathXY, inputType, hPoints)
% Updates the drawing based on the selected inputType

switch inputType
    case 'path'
        updateLineObject(hPoints, pathXY);

    case 'points'
        updateLineObject(hPoints, pathXY);

    case 'patch'
        % Keep NaN rows so right-click can separate different patches
        patchXY = pathXY;

        % Show the clicked points/edges as an editable red line
        updateLineObject(hPoints, patchXY);

        % Draw the filled patch separately underneath the editable line
        updatePatchObjects(patchXY);

    case 'aabb'
        aabbXY = fcn_INTERNAL_buildaabbFromTwoPoints(pathXY);
        updateLineObject(hPoints, aabbXY);

        if size(aabbXY,1) >= 5
            closedAreaXY = aabbXY(1:end-1,:);
        else
            closedAreaXY = [];
        end

    case 'directedpath'
        updateLineObject(hPoints, pathXY);
        updateDirectedPathObjects(pathXY);

    case 'onesidedsegment'
        oneSidedSegmentXY = fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath(pathXY);
        updateLineObject(hPoints, oneSidedSegmentXY);
        updateOneSidedSegmentObjects(oneSidedSegmentXY);

    otherwise
        error('Unknown inputType. Use path, points, patch, aabb, directedpath, or onesidedsegment.');
end

drawnow;
end % Ends fcn_INTERNAL_updateDrawing