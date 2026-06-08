function [pathXY, closedAreaXY] = fcn_GetUserInputPath_getUserInputPath(varargin)
% fcn_GetUserInputPath_getUserInputPath
%
% A function for the user to click on the figure to generate XY user input
% until the user hits the "return" key. The function supports different
% drawing/input styles through the optional inputType argument:
%
%   'path'   - default behavior. The user-selected points are displayed as
%              connected line segments.
%
%   'points' - the user-selected points are displayed as individual points
%              without connecting line segments.
%
%   'patch'  - the user-selected points are displayed as a closed patch.
%              When at least 3 valid points are available, the patch is
%              drawn by connecting the selected points in order. If fewer
%              than 3 valid points are available, the input is displayed
%              like a path so the user can still see the selected points.
%
%   'aabb'   - the user selects two opposite corners, and the function
%              returns the axis-aligned bounding box defined by those points.
%              This mode is intended to define one AABB per function call.
%              If additional points are selected, the second corner is
%              updated rather than creating multiple boxes.
%
%   'directedpath' - the user-selected points are displayed as a directed
%                    path using arrows between consecutive points. This mode
%                    supports both normal XY axes and GeographicAxes.
%
%   'onesidedsegment' - the user selects pairs of points defining one-sided
%                       segments. A small perpendicular arrow is drawn to
%                       indicate the positive/visible side of each segment.
%                       The positive side is the left side when moving from
%                       the start point to the end point. Multiple segments
%                       can be separated using right-click [nan nan] rows.
%
% If the user right-clicks, the function inserts a [nan nan] row, which
% effectively creates a gap in the plotted path. If the user hits the
% "minus" or hyphen key, it removes the most recent point.
%
% As an optional input, the function can start with a startingXY point
% list, plotting this first.
%
% FORMAT:
%
%      pathXY = fcn_GetUserInputPath_getUserInputPath((startingXY),(figNum),(inputType))
%
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      startingXY - initial XY points to use.
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
%      inputType - string specifying the drawing/input style. Options are:
%                  'path'   - default. Displays selected points as connected
%                             line segments.
%                  'points' - displays selected points only, without
%                             connecting line segments.
%                  'patch'  - displays selected points as a closed patch.
%                             Patches are filled when at least 3 valid
%                             points are available.
%                  'aabb'   - displays an axis-aligned bounding box using
%                             two selected opposite corners. This mode
%                             defines one AABB per function call.
%
%                  'directedpath' - displays selected points as a directed
%                                   path using arrows between consecutive
%                                   points.
%                  'onesidedsegment' - displays two-point segments with a
%                                      perpendicular arrow indicating the
%                                      positive/visible side. The positive
%                                      side is the left side when moving
%                                      from start point to end point.


% OUTPUTS:
%      pathXY: matrix (Nx2) representing the X and Y points that the user
%      clicked on the map.
%
%      closedAreaXY: legacy output retained for backward compatibility.
%      This output is currently returned as empty.
%
%  EXAMPLES:
%
%      % BASIC example using default path mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath
%
%      % Example using path mode explicitly
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'path')
%
%      % Example using points mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'points')
%
%      % Example using patch mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'patch')
%
%      % Example using aabb mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'aabb')
%
%      % Example using directedpath mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'directedpath')
%
%      % Example using onesidedsegment mode
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'onesidedsegment')
%
% See the script: script_test_fcn_GetUserInputPath_getUserInputPath
% for a full test suite.
%
% This function was written on 2020_10_15 by S. Brennan
% This function was edited on 2026_05_15 by Jaime Rodriguez
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: fcn_pathtools_getUserInputPath
%
% 2020_10_15 - wrote the code
%
% As: fcn_GetUserInputPath_getUserInputPath
%
% 2026_02_12 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Renamed function to library standard
%   % * Modified to allow real-time plotting
%
% 2026_02_13 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Updated to support panning with mouse without interrupting point
%   %   capture
%
% 2026_03_06 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Updated to support point deletion
%   % * Updated to support point insertion
%   % * Updated to support click-to-drag of points
%   % * Updated to support cling on legend to exit
%   % * Forces close of the figure upon completion
%
% 2026_05_15 by Jaime Rodriguez
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Added inputType optional argument to support multiple drawing modes:
%   %   'path', 'points', and 'patch'.
%   % * Preserved 'path' as the default behavior, where user-selected points
%   %   are displayed as connected line segments.
%   % * Added 'points' mode, where user-selected points are displayed as
%   %   individual markers without connecting line segments.
%   % * Updated patch display behavior so that, when fewer than 3 valid
%   %   points are available, the selected points are displayed like a path
%   %   instead of an empty patch.
%   % * Added fcn_INTERNAL_splitPathByNaNs helper function to split user input
%   %   paths into subpaths separated by [nan nan] rows.
%   % * Added updateDrawing internal function to centralize display updates
%   %   across path, points, and patch modes.
%   % * Added manual axis-limit mode after creating the drawing object to help
%   %   prevent MATLAB from auto-zooming when points are added.
%
% 2026_05_19 by Jaime Rodriguez
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Added 'aabb' inputType, where the user selects two opposite corners
%   %   and the function returns the corresponding axis-aligned bounding box.
%   % * Added support for filled patch rendering in normal XY axes using
%   %   separate patch objects underneath the editable user-selected outline.
%   % * Added support for filled patch rendering in GeographicAxes using
%   %   geopolyshape and geoplot.
%   % * Updated patch drawing so that right-click [NaN NaN] separators allow
%   %   the user to create multiple independent patch areas.
%   % * Updated patch drawing so that the editable outline remains visible
%   %   above the filled patch area.
%   % * Updated GeographicAxes support for path, points, patch, and aabb
%   %   drawing modes.
%   % * Updated GeographicAxes panning behavior so map limits are shifted
%   %   consistently using latitude and longitude limits.
%   % * Added updateLineObject helper function to update either normal plot
%   %   objects or geographic plot objects depending on the axes type.
%
% 2026_05_20 by Jaime Rodriguez
% - In fcn_GetUserInputPath_getUserInputPath
%   % * In the path mode, for example demo 10001, if someone clicks "c",
%   the code incorrectly closes the points by connecting many to the first
%   one. Seems that "c" should just close only the current path, not many
%   paths. Not sure if this is related to patchCloseMode - not sure how
%   this option works. Why is this an option (unclear)?--SOLVED BY DELETING
%   C COMMAND AND PATCHCLOSEMODE
%
%   % * Getting an error "Invalid figure handle" (line 974) when closing
%   figure manually (clicking on "X" and not on the legend patch)--SOLVED
%
%   % * Make sure all sections have assertion tests to avoid warnings (see
%   warnings on Line 442 for example)--SOLVED
% - In script_test_fcn_GetUserInputPath_getUserInputPath
%   % * The 'i' input fixed
%   % * DeleteD 10008 example
%   % * The aabb mode seems to only allow one AABB to be entered. This is
%   fine and makes sense, see for example test 20005, but seems like we
%   should document this in the header comments--SOLVED
%
% 2026_05_27 by Jaime Rodriguez
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Added 'directedpath' and 'onesidedsegment' inputTypes.
%   % * Added arrow-based visualization for both normal XY axes and
%   %   GeographicAxes.
%   % * Added support for multiple one-sided segments separated by [NaN NaN]
%   %   rows.
%   % * Updated GeographicAxes point-dragging behavior so moved points remain
%   %   at the user-selected map location.

% TO-DO:
% - 2026_02_12 by Sean Brennan, sbrennan@psu.edu
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
        narginchk(0,MAX_NARGIN);

        % validateattributes(L,{'numeric'},{'scalar','positive'});
        % validateattributes(W,{'numeric'},{'scalar','positive'});


    end
end
% Does the user want to specify the startingXY?
pathXY = [];  % Default case
closedAreaXY = []; % Stores the closed area generated from path mode

if 1 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
        pathXY = temp;
    end
end

% Does user want to specify the figure number?
figNum = [];
flag_do_plots = 1; % Default is to show plots
if 2 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
        figNum = temp;
        flag_do_plots = 1;
    end
end

if isempty(figNum)
    temp = figure;
    figNum = get(temp,'Number');
end

% Does the user want to specify the input type?
% Options:
%   'path'   - default, connected line segments
%   'points' - points only, no lines
%   'patch'  - closed polygon/patch
%   'aabb'   - axis aligned bounding box from two selected cornerss
%   'directedpath'   - connected line segments with arrows
%   'onesidedsegment' - displays a two-point segment with a perpendicular
%                       arrow indicating the positive/visible side.

inputType = 'path'; % default
if 3 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
        inputType = lower(temp);
    end
end

validInputTypes = {'path','points','patch','aabb','directedpath','onesidedsegment'};
if ~any(strcmp(inputType,validInputTypes))
    error('inputType must be one of: path, points, patch, aabb, directedpath, or onesidedsegment');
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

% Controls whether path subpaths are visually closed by connecting
% nearest free endpoints. This does not modify pathXY.

h_fig = figure(figNum);

% For debuggin
warning('backtrace','on');

ax = gca;

flag_isGeoPlot = isa(ax,'matlab.graphics.axis.GeographicAxes');

hold(ax, 'on')

% Store state in figure appdata
setappdata(figNum,'HoldPanState',struct( ...
    'active',false, ...
    'startPoint',[0 0], ...
    'startXLim',[0 0], ...
    'startYLim',[0 0], ...
    'button',[], ...
    'legendClicked',false, ...
    'MoveIndex',[], ...
    'hasDragged',false, ...
    'ignoreNextButtonUp',false));

if isempty(pathXY)
    pathXY = [nan nan];
end


% Create a plot
% Create the user input drawing object
switch inputType
    case 'path'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected path');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected path');
        end

    case 'points'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.', ...
                'MarkerSize',20, ...
                'DisplayName','User selected points');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
                'r.', ...
                'MarkerSize',20, ...
                'DisplayName','User selected points');
        end

    case 'patch'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected patch');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected patch');
        end

    case 'aabb'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected aabb');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected aabb');
        end

    case 'directedpath'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected directed path');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
                'r.', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected directed path');
        end

    case 'onesidedsegment'
        if flag_isGeoPlot
            hPoints = geoplot(ax, pathXY(:,1), pathXY(:,2), ...
                'r.-', ...
                'MarkerFaceColor','r', ...
                'DisplayName','User selected one-sided segment');
        else
            hPoints = plot(pathXY(:,1), pathXY(:,2), ...
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

% Handles for filled patch objects in patch mode
hPatchObjects = gobjects(0);

% Handles for quiver objects in directed path and one-sided segment modes
hQuiverObjects = gobjects(0);

% Freeze the axis limits so MATLAB does not auto-zoom when points are added
if ~flag_isGeoPlot
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
end

% Create the "exit" object
if flag_isGeoPlot
    % Do not use geopolyshape here because it requires Mapping Toolbox.
    % A NaN geoplot line is enough to create a clickable legend item.
    hExitPatch = geoplot(ax, nan, nan, ...
        'b-', ...
        'LineWidth',6, ...
        'DisplayName','Click Here To Exit');
else
    hExitPatch = patch('XData',nan, ...
        'YData',nan, ...
        'FaceColor',[0 0 1], ...
        'DisplayName','Click Here To Exit');
end

% Force legend order
h_legend = legend(ax,[hPoints hExitPatch], ...
    'Interpreter','none', ...
    'Location','northeast');

% Prevent legend from adding a new entry every time the drawing updates
h_legend.AutoUpdate = 'off';

% Set ItemHitFcn
h_legend.ItemHitFcn = @(src,event) legendItemClicked(src,event);

set(h_fig, ...
    'WindowButtonDownFcn', @onClick, ...
    'WindowKeyPressFcn', @onKey, ...
    'WindowButtonMotionFcn', @onMouseMove, ...
    'WindowButtonUpFcn',   @onButtonUp);

title({'Click to add points. Right-click inserts gap. Click-drag shifts point or moves axis.', ...
    '(-) removes prior point. (d) deletes closest point. (i) inserts point. Press Enter to finish.'});

uiwait(figNum);    % block until uiresume or figure closed

% If in aabb mode, return the final aabb instead of the two raw clicked points
if strcmp(inputType,'aabb')
    aabbXY = fcn_INTERNAL_buildaabbFromTwoPoints(pathXY);

    if size(aabbXY,1) >= 5
        pathXY = aabbXY;
        closedAreaXY = aabbXY(1:end-1,:);
    end
end

% If in onesidedsegment mode, return only the first two valid points of each segment
if strcmp(inputType,'onesidedsegment')
    pathXY = fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath(pathXY);
    closedAreaXY = [];
end

    function updateDrawing()
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
    end

    function updateLineObject(hLine, displayXY)
        % Updates either a normal plot object or a geoplot object.

        if isprop(hLine,'LatitudeData') && isprop(hLine,'LongitudeData')
            set(hLine, ...
                'LatitudeData', displayXY(:,1), ...
                'LongitudeData', displayXY(:,2));
        else
            set(hLine, ...
                'XData', displayXY(:,1), ...
                'YData', displayXY(:,2));
        end
    end

    function currentPointXY = getCurrentPointXY()
    	% Gets current cursor point in the current axes coordinate order.
    	currentPoint = get(ax,'CurrentPoint');
    	currentPointXY = currentPoint(1,1:2);
    end

    function updatePatchObjects(patchXY)
    	% Deletes and redraws separate filled patch objects.
    	% Each subpath separated by [NaN NaN] becomes its own patch.

    	% Delete old patch objects
    	if ~isempty(hPatchObjects)
    		for ith_patch = 1:length(hPatchObjects)
    			if isgraphics(hPatchObjects(ith_patch))
    				delete(hPatchObjects(ith_patch));
    			end
    		end
    	end

    	hPatchObjects = gobjects(0);

    	% Split into separate patch candidates
    	subPaths = fcn_INTERNAL_splitPathByNaNs(patchXY);

    	for ith_subpath = 1:length(subPaths)

    		thisPatchXY = subPaths{ith_subpath};

    		% A patch needs at least 3 valid points
            if size(thisPatchXY,1) >= 3

                if flag_isGeoPlot
        	        % GeographicAxes case.
        	        % pathXY/geoplot data are assumed to be [Latitude Longitude].
        	        latitudes  = thisPatchXY(:,1);
        	        longitudes = thisPatchXY(:,2);

                    % Ensure the polygon is explicitly closed
                    if ~isequal([latitudes(1) longitudes(1)], [latitudes(end) longitudes(end)])
        	            latitudes  = [latitudes; latitudes(1)];
        	            longitudes = [longitudes; longitudes(1)];
                    end

        	        % geopolyshape expects valid polygon topology. For outer boundaries,
        	        % clockwise vertex order is generally required.
        	        % Use longitude as X and latitude as Y for the signed area check.
        	        signedArea = 0.5 * sum( ...
        		        longitudes(1:end-1).*latitudes(2:end) - ...
        		        longitudes(2:end).*latitudes(1:end-1));

        	        % Positive signed area means counter-clockwise, so reverse it
        	        if signedArea > 0
        		        latitudes  = flipud(latitudes);
        		        longitudes = flipud(longitudes);
        	        end

        	        geoPatchShape = geopolyshape(latitudes, longitudes);

        	        hPatchObjects(end+1) = geoplot(ax, geoPatchShape, ...
        		        'FaceColor','red', ...
        		        'FaceAlpha',0.2, ...
        		        'EdgeColor','red', ...
        		        'LineWidth',1.5, ...
        		        'HandleVisibility','off');

    			else
    				% Normal XY axes case
    				hPatchObjects(end+1) = patch('XData',thisPatchXY(:,1), ...
    					'YData',thisPatchXY(:,2), ...
    					'FaceColor','red', ...
    					'FaceAlpha',0.2, ...
    					'EdgeColor','red', ...
    					'LineWidth',1.5, ...
    					'HitTest','off', ...
    					'PickableParts','none', ...
    					'HandleVisibility','off'); %#ok<AGROW>
                end
            end
    	end

    	% Keep clicked points/line above filled patches
        if isgraphics(hPoints)
    		uistack(hPoints,'top');
        end
    end

    function deleteQuiverObjects()
    	% Deletes old quiver objects used by directed path and one-sided segment modes.

    	if ~isempty(hQuiverObjects)
    		for ith_quiver = 1:length(hQuiverObjects)
    			if isgraphics(hQuiverObjects(ith_quiver))
    				delete(hQuiverObjects(ith_quiver));
    			end
    		end
    	end

    	hQuiverObjects = gobjects(0);
    end

    function updateDirectedPathObjects(directedPathXY)
    	% Draws arrows between consecutive valid points in directed path mode.
    	%
    	% In normal XY axes, arrows are drawn using quiver.
    	% In GeographicAxes, arrows are drawn manually using geoplot because
    	% quiver is not compatible with GeographicAxes in the same way.

    	deleteQuiverObjects();

    	subPaths = fcn_INTERNAL_splitPathByNaNs(directedPathXY);

    	for ith_subpath = 1:length(subPaths)

    		thisPathXY = subPaths{ith_subpath};

    		if size(thisPathXY,1) >= 2

    			if flag_isGeoPlot

    				% GeographicAxes case.
    				% pathXY is assumed to be [Latitude Longitude].
    				for ith_segment = 1:(size(thisPathXY,1)-1)

    					latStart = thisPathXY(ith_segment,1);
    					lonStart = thisPathXY(ith_segment,2);

    					latEnd = thisPathXY(ith_segment+1,1);
    					lonEnd = thisPathXY(ith_segment+1,2);

    					dLat = latEnd - latStart;
    					dLon = lonEnd - lonStart;

    					segmentLength = hypot(dLat,dLon);

    					if segmentLength <= 0
    						continue;
    					end

    					% Unit direction vector in latitude/longitude space
    					unitLat = dLat/segmentLength;
    					unitLon = dLon/segmentLength;

    					% Arrow head size, relative to segment length
    					arrowHeadLength = 0.25*segmentLength;
    					arrowHeadWidth  = 0.12*segmentLength;

    					% Base point of the arrow head
    					latBase = latEnd - arrowHeadLength*unitLat;
    					lonBase = lonEnd - arrowHeadLength*unitLon;

    					% Perpendicular vector
    					perpLat = -unitLon;
    					perpLon =  unitLat;

    					% Arrow head left and right points
    					latLeft = latBase + arrowHeadWidth*perpLat;
    					lonLeft = lonBase + arrowHeadWidth*perpLon;

    					latRight = latBase - arrowHeadWidth*perpLat;
    					lonRight = lonBase - arrowHeadWidth*perpLon;

    					% Draw main arrow shaft
    					hQuiverObjects(end+1) = geoplot(ax, ...
    						[latStart latEnd], ...
    						[lonStart lonEnd], ...
    						'r-', ...
    						'LineWidth',1.5, ...
    						'HandleVisibility','off'); %#ok<AGROW>

    					% Draw arrow head
    					hQuiverObjects(end+1) = geoplot(ax, ...
    						[latLeft latEnd latRight], ...
    						[lonLeft lonEnd lonRight], ...
    						'r-', ...
    						'LineWidth',1.5, ...
    						'HandleVisibility','off'); %#ok<AGROW>
    				end

    			else

    				% Normal XY axes case
    				xStart = thisPathXY(1:end-1,1);
    				yStart = thisPathXY(1:end-1,2);

    				dx = thisPathXY(2:end,1) - thisPathXY(1:end-1,1);
    				dy = thisPathXY(2:end,2) - thisPathXY(1:end-1,2);

    				hQuiverObjects(end+1) = quiver(ax, ...
    					xStart, yStart, dx, dy, ...
    					0, ...
    					'Color','r', ...
    					'LineWidth',1.5, ...
    					'MaxHeadSize',0.5, ...
    					'HandleVisibility','off'); %#ok<AGROW>
    			end
    		end
    	end

    	if isgraphics(hPoints)
    		uistack(hPoints,'top');
    	end
    end
    function updateOneSidedSegmentObjects(segmentXY)
        % Draws a perpendicular arrow showing the positive side of each segment.
        % The positive side is the left side when moving from start point to end point.

        deleteQuiverObjects();

        subPaths = fcn_INTERNAL_splitPathByNaNs(segmentXY);

        for ith_subpath = 1:length(subPaths)

            thisSegmentXY = subPaths{ith_subpath};

            if size(thisSegmentXY,1) < 2
                continue;
            end

            pointStart = thisSegmentXY(1,:);
            pointEnd   = thisSegmentXY(2,:);

            dx = pointEnd(1) - pointStart(1);
            dy = pointEnd(2) - pointStart(2);

            segmentLength = hypot(dx,dy);

            if segmentLength <= 0
                continue;
            end

            midPoint = 0.5*(pointStart + pointEnd);

            % Positive side: left side when moving from start to end
            normalVector = [-dy dx] ./ segmentLength;

            arrowLength = 0.18 * segmentLength;

            if flag_isGeoPlot

                % GeographicAxes case.
                % pathXY is assumed to be [Latitude Longitude].
                % Work in local meter coordinates instead of raw lat/lon degrees.

                latStart = pointStart(1);
                lonStart = pointStart(2);

                latEnd = pointEnd(1);
                lonEnd = pointEnd(2);

                latRef = 0.5*(latStart + latEnd);

                metersPerDegLat = 111320;
                metersPerDegLon = 111320*cosd(latRef);

                xStart_m = lonStart * metersPerDegLon;
                yStart_m = latStart * metersPerDegLat;

                xEnd_m = lonEnd * metersPerDegLon;
                yEnd_m = latEnd * metersPerDegLat;

                dx_m = xEnd_m - xStart_m;
                dy_m = yEnd_m - yStart_m;

                segmentLength_m = hypot(dx_m,dy_m);

                if segmentLength_m <= 0
                    continue;
                end

                midX_m = 0.5*(xStart_m + xEnd_m);
                midY_m = 0.5*(yStart_m + yEnd_m);

                % Positive side: left side when moving from start to end
                normalX_m = -dy_m/segmentLength_m;
                normalY_m =  dx_m/segmentLength_m;

                % Side arrow length in meters
                arrowLength_m = 0.18 * segmentLength_m;

                xArrowStart_m = midX_m;
                yArrowStart_m = midY_m;

                xArrowEnd_m = midX_m + arrowLength_m*normalX_m;
                yArrowEnd_m = midY_m + arrowLength_m*normalY_m;

                latStartArrow = yArrowStart_m / metersPerDegLat;
                lonStartArrow = xArrowStart_m / metersPerDegLon;

                latEndArrow = yArrowEnd_m / metersPerDegLat;
                lonEndArrow = xArrowEnd_m / metersPerDegLon;

                % Draw perpendicular side indicator shaft
                hQuiverObjects(end+1) = geoplot(ax, ...
                    [latStartArrow latEndArrow], ...
                    [lonStartArrow lonEndArrow], ...
                    'r-', ...
                    'LineWidth',4, ...
                    'HandleVisibility','off'); %#ok<AGROW>

                % Arrow head in local meter coordinates
                headLength_m = 0.20 * arrowLength_m;
                headWidth_m  = 0.12 * arrowLength_m;

                headTip_m  = [xArrowEnd_m yArrowEnd_m];
                headBase_m = headTip_m - headLength_m*[normalX_m normalY_m];

                arrowPerp_m = [-normalY_m normalX_m];

                headLeft_m  = headBase_m + headWidth_m*arrowPerp_m;
                headRight_m = headBase_m - headWidth_m*arrowPerp_m;

                latHeadLeft  = headLeft_m(2) / metersPerDegLat;
                lonHeadLeft  = headLeft_m(1) / metersPerDegLon;

                latHeadRight = headRight_m(2) / metersPerDegLat;
                lonHeadRight = headRight_m(1) / metersPerDegLon;

                latHeadTip = headTip_m(2) / metersPerDegLat;
                lonHeadTip = headTip_m(1) / metersPerDegLon;

                % Draw arrow head left side
                hQuiverObjects(end+1) = geoplot(ax, ...
                    [latHeadLeft latHeadTip], ...
                    [lonHeadLeft lonHeadTip], ...
                    'r-', ...
                    'LineWidth',4, ...
                    'HandleVisibility','off'); %#ok<AGROW>

                % Draw arrow head right side
                hQuiverObjects(end+1) = geoplot(ax, ...
                    [latHeadRight latHeadTip], ...
                    [lonHeadRight lonHeadTip], ...
                    'r-', ...
                    'LineWidth',4, ...
                    'HandleVisibility','off'); %#ok<AGROW>

            else

                % Normal XY axes case
                hQuiverObjects(end+1) = quiver(ax, ...
                    midPoint(1), midPoint(2), ...
                    arrowLength*normalVector(1), arrowLength*normalVector(2), ...
                    0, ...
                    'Color','r', ...
                    'LineWidth',3, ...
                    'MaxHeadSize',1.5, ...
                    'HandleVisibility','off'); %#ok<AGROW>
            end
        end

        if isgraphics(hPoints)
            uistack(hPoints,'top');
        end
    end
    function legendItemClicked(~, event)
        s = getappdata(figNum,'HoldPanState');
        s.legendClicked = true;
        setappdata(figNum,'HoldPanState',s);

        % event.Peer      -> chart object associated with clicked legend item
        % event.Region    -> 'icon' or 'label'
        % event.SelectionType -> 'normal','extend','open','alt'

        h_Peer = event.Peer;
        h_PeerStruct = get(event.Peer);
        peerDisplayName = h_PeerStruct.DisplayName;

        % For debugging
        if 1==0
            fprintf(1,'Region: %s, SelectionType: %s, Name: %s \n', event.Region, event.SelectionType, peerDisplayName);
        end

        if strcmp(peerDisplayName,'Click Here To Exit')
            % set(h_fig, ...
            % 	'WindowButtonDownFcn', '', ...
            % 	'WindowKeyPressFcn', '', ...
            % 	'WindowButtonMotionFcn', '', ...
            % 	'WindowButtonUpFcn',   '');
            % h_legend.ItemHitFcn = [];
            % legend('off');
            uiresume(figNum);
        end

        if isprop(h_Peer,'Visible') || isfield(h_Peer,'Visible')
            h_Peer.Visible = toggle(h_Peer.Visible);   % toggle visibility
        end
    end

    function v = toggle(prev)
        if strcmp(prev,'on')
            v = 'off';
        else
            v = 'on';
        end
    end


    function onClick(~,~)
    	% Called when a plot is clicked

        if ~ishandle(ax)
            return;
        end

        sel = get(h_fig,'SelectionType');    % 'normal' left, 'alt' right, 'open' double
        subtitle(sprintf('Sel: %s',sel));

        if strcmp(sel,'normal')           % only left-clicks add points or pans

            s = getappdata(figNum,'HoldPanState');
            s.active = true;
            s.button = sel;
            s.hasDragged = false;

            % starting data point in axes coordinates
            currentPointXY = getCurrentPointXY();
            s.startPoint = currentPointXY;

    		% Get current axis limits
  	      if flag_isGeoPlot
              [latlimOut,lonlimOut] = geolimits;

              % In GeographicAxes, pathXY is stored as [Latitude Longitude].
              % Therefore, startXLim corresponds to the first column latitude,
              % and startYLim corresponds to the second column longitude.
              s.startXLim = latlimOut;
              s.startYLim = lonlimOut;
          else
              s.startXLim = ax.XLim;
              s.startYLim = ax.YLim;
          end
  		% Check whether the click is close to an existing point
        closestIndex = fcn_INTERNAL_findNearestPointIndex( ...
            s.startXLim, s.startYLim, pathXY, currentPointXY, 0.01);

        s.MoveIndex = closestIndex;

        % Save current state
        setappdata(figNum,'HoldPanState',s);

        % enable motion callback
        set(figNum,'WindowButtonMotionFcn',@onMouseMove);

        elseif strcmp(sel,'alt')
            pathXY(end+1,:) = [nan nan];         % append nan

            s = getappdata(figNum,'HoldPanState');
            s.active = false;
            s.hasDragged = false;
            s.ignoreNextButtonUp = true;
            setappdata(figNum,'HoldPanState',s);

            updateDrawing();                      % update immediately	    else
            return;
        end
    end

    function onMouseMove(~,~)
        currentPointXY = getCurrentPointXY();
        subtitle(['(X,Y) = (', num2str(currentPointXY(1)), ', ',num2str(currentPointXY(2)), ')']);

        s = getappdata(figNum,'HoldPanState');

    	% If mouse is not down, only update coordinate display.
        if ~s.active
            return;
        end

        positionChange = currentPointXY - s.startPoint;

        xAxisRange = s.startXLim(2) - s.startXLim(1);
        yAxisRange = s.startYLim(2) - s.startYLim(1);

        if xAxisRange == 0 || yAxisRange == 0
            return;
        end

    	normalizedChange = norm(positionChange ./ [xAxisRange yAxisRange]);

        % Ignore tiny mouse movements during normal clicks
        dragThreshold = 0.02;

        if normalizedChange < dragThreshold
            return;
        end

        s.hasDragged = true;
        setappdata(figNum,'HoldPanState',s);

        if isempty(s.MoveIndex)

    		% Pan mode
            dx = currentPointXY(1) - s.startPoint(1);
            dy = currentPointXY(2) - s.startPoint(2);

            if flag_isGeoPlot
                % currentPointXY is stored as [Latitude Longitude]
                dLat = currentPointXY(1) - s.startPoint(1);
                dLon = currentPointXY(2) - s.startPoint(2);

                % For GeographicAxes:
                % s.startXLim stores latitude limits
                % s.startYLim stores longitude limits
                newLatitudeLimits  = s.startXLim - dLat;
                newLongitudeLimits = s.startYLim - dLon;

                geolimits(newLatitudeLimits,newLongitudeLimits);
            else
                ax.XLim = s.startXLim - dx;
                ax.YLim = s.startYLim - dy;
            end

        else
    		% Move point mode
            xl = s.startXLim;
            yl = s.startYLim;

            newx = max(min(currentPointXY(1),xl(2)),xl(1));
            newy = max(min(currentPointXY(2),yl(2)),yl(1));

            pathXY(s.MoveIndex,:) = [newx newy];

            updateDrawing();
        end

        drawnow limitrate;
    end

    function onButtonUp(~,~)
    	s = getappdata(figNum,'HoldPanState');

        if isfield(s,'ignoreNextButtonUp') && s.ignoreNextButtonUp
            s.ignoreNextButtonUp = false;
            setappdata(figNum,'HoldPanState',s);
            return;
        end

    	if s.active
    		s.active = false;
    	end

    	if s.legendClicked
    		s.legendClicked = false;
    		setappdata(figNum,'HoldPanState',s);
    		return;
    	end

    	% If the user dragged, do not add a new point
    	if isfield(s,'hasDragged') && s.hasDragged
    		s.hasDragged = false;
    		setappdata(figNum,'HoldPanState',s);
    		return;
    	end

    	% If no drag occurred, treat this as a click and add a point
    	currentPointXY = getCurrentPointXY();
    	x = currentPointXY(1);
    	y = currentPointXY(2);

        if strcmp(inputType,'aabb')
            validRows = ~any(isnan(pathXY),2);
            NvalidPoints = sum(validRows);

            if all(isnan(pathXY),'all')
                pathXY(1,:) = [x, y];

            elseif NvalidPoints < 2
                pathXY(end+1,:) = [x, y];

            else
                validIndices = find(validRows);
                pathXY(validIndices(2),:) = [x, y];
            end

        elseif strcmp(inputType,'onesidedsegment')

            newPointXY = [x y];

            if isempty(pathXY) || all(isnan(pathXY),'all')
                pathXY = newPointXY;
            else
                pathXY = fcn_INTERNAL_addPointToOneSidedSegmentPath(pathXY,newPointXY);
            end

        else
            if all(isnan(pathXY),'all')
                pathXY(1,:) = [x, y];
            else
                pathXY(end+1,:) = [x y];
            end
        end

    	setappdata(figNum,'HoldPanState',s);
    	updateDrawing();
    end

    function onKey(~,event)
        % User pressed a key on the keyboard
        keyPress = event.Key;
        % if strcmp(event.Key,'return')
        % end

        switch keyPress
            case 'return'     % finish on Enter
                uiresume(figNum);

                % disp('Points collected:');
                % disp(pts);
                % uiresume(h_fig);               % optional: resume if waiting
                % close(h_fig);                  % optional: close figure

            case {'hyphen','subtract'} % Removes the last point
                if size(pathXY,1)>0
                    pathXY(end,:) = [];
                end
                if isempty(pathXY)
                    pathXY = [nan nan];
                end
                updateDrawing();                    % update immediately

            case 'i' % Insert a new point into the nearest path segment

            	% Get current cursor point
            	currentPointXY = getCurrentPointXY();

                if strcmp(inputType,'aabb')
                    % aabb mode only keeps two corner points
                    validRows = ~any(isnan(pathXY),2);
                    NvalidPoints = sum(validRows);

                    if isempty(pathXY) || all(isnan(pathXY),'all')
                        pathXY = currentPointXY;

                    elseif NvalidPoints < 2
                        pathXY(end+1,:) = currentPointXY;

                    else
                        % Replace second corner if two already exist
                        validIndices = find(validRows);
                        pathXY(validIndices(2),:) = currentPointXY;
                    end

                elseif strcmp(inputType,'onesidedsegment')
                    % onesidedsegment keeps two points per segment/subpath
                    if isempty(pathXY) || all(isnan(pathXY),'all')
                        pathXY = currentPointXY;
                    else
                        pathXY = fcn_INTERNAL_addPointToOneSidedSegmentPath(pathXY,currentPointXY);
                    end

            	elseif strcmp(inputType,'points')
            		% In points mode there are no line segments, so append the point.
            		if isempty(pathXY) || all(isnan(pathXY),'all')
            			pathXY = currentPointXY;
            		else
            			pathXY(end+1,:) = currentPointXY;
            		end

            	else
            		% In path and patch modes, insert the point into the nearest segment.

            		if isempty(pathXY) || all(isnan(pathXY),'all')
            			pathXY = currentPointXY;

            		else
            			% Break path into subpaths because snap/insertion cannot work
            			% directly across [NaN NaN] separator rows.
            			cellArrayOfSubPathIndices = fcn_DebugTools_breakArrayByNans(pathXY,-1);

            			nearestDistance = inf;
            			first_path_point_index = [];
            			second_path_point_index = [];
            			flag_isStartOrEnd = 0;

            			for ith_subpath = 1:length(cellArrayOfSubPathIndices)

            				thisIndices = cellArrayOfSubPathIndices{ith_subpath};
            				thisSubPath = pathXY(thisIndices,:);

            				% Skip empty or invalid subpaths
            				if isempty(thisSubPath) || all(isnan(thisSubPath),'all')
            					continue;
            				end

            				thisOffsetIndex = thisIndices(1);

            				if size(thisSubPath,1) == 1
            					% With only one point, compare directly to that point.
            					thisDistance = sum((thisSubPath(1,:) - currentPointXY).^2);

            					if thisDistance < nearestDistance
            						nearestDistance = thisDistance;
            						first_path_point_index = thisOffsetIndex;
            						second_path_point_index = thisOffsetIndex;
            						flag_isStartOrEnd = 1;
            					end

            				else
            					% Snap point onto nearest path segment
            					[closest_path_point,~,~, ...
            						this_first_path_point_index, ...
            						this_second_path_point_index, ...
            						~] = fcn_Path_snapPointOntoNearestPath(currentPointXY, thisSubPath, -1);

            					thisDistance = sum((closest_path_point-currentPointXY).^2,2);

            					if thisDistance < nearestDistance
            						nearestDistance = thisDistance;
            						first_path_point_index = this_first_path_point_index + thisOffsetIndex - 1;
            						second_path_point_index = this_second_path_point_index + thisOffsetIndex - 1;

            						flag_isStartOrEnd = 0;
            						if this_first_path_point_index == this_second_path_point_index
            							if this_first_path_point_index == 1
            								flag_isStartOrEnd = -1;
            							else
            								flag_isStartOrEnd = 1;
            							end
            						end
            					end
            				end
            			end

            			% If no valid insertion location was found, append as fallback
            			if isempty(first_path_point_index) || isempty(second_path_point_index)
            				pathXY(end+1,:) = currentPointXY;

            			elseif first_path_point_index == second_path_point_index

            				if first_path_point_index == 1
            					% Insert at very front
            					pathXY = [currentPointXY; pathXY];

            				elseif first_path_point_index == size(pathXY,1)
            					% Insert at very end
            					pathXY = [pathXY; currentPointXY];

            				elseif flag_isStartOrEnd == -1
            					% Insert at front of subsegment but not very front
            					pathXY = [pathXY(1:first_path_point_index-1,:); ...
            						currentPointXY; ...
            						pathXY(first_path_point_index:end,:)];

            				else
            					% Insert at end of subsegment but not very end
            					pathXY = [pathXY(1:first_path_point_index,:); ...
            						currentPointXY; ...
            						pathXY(first_path_point_index+1:end,:)];
            				end

            			else
            				% Insert between nearest segment endpoints
            				pathXY = [pathXY(1:first_path_point_index,:); ...
            					currentPointXY; ...
            					pathXY(second_path_point_index:end,:)];
            			end
            		end
            	end

            	updateDrawing();
            case 'd' % Delete a point
                if size(pathXY,1)<2
                    pathXY = [nan nan];
                    return;
                end

                % Find closest point
                currentPointXY = getCurrentPointXY();

                % Get current axis limits
                s = getappdata(figNum,'HoldPanState');
                if flag_isGeoPlot
                    [latlimOut,lonlimOut] = geolimits;

                    % In GeographicAxes, pathXY is stored as [Latitude Longitude].
                    s.startXLim = latlimOut;
                    s.startYLim = lonlimOut;
                else
                    s.startXLim = ax.XLim;
                    s.startYLim = ax.YLim;
                end

                %%%%%%%%%%%%%
                % FORMAT:
                % closestIndex = fcn_INTERNAL_findNearestPointIndex(xlimits, ylimits, pathXY, currentPointXY, threshold)
                closestIndex = fcn_INTERNAL_findNearestPointIndex(s.startXLim, s.startYLim, pathXY, currentPointXY, 1);

                % Remove it from the list
                pathXY(closestIndex,:) = [];

                updateDrawing();                      % update immediately

            otherwise
                % No action for this keypress
        end
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
if ishandle(figNum)
    close(figNum);
end

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


function closestIndex = fcn_INTERNAL_findNearestPointIndex(xlimits, ylimits, pathXY, currentPointXY, threshold)
% Check to see if mouse click is on top of existing point
% Find nearest point in the clicked handle

xAxisRange = xlimits(2) - xlimits(1);
yAxisRange = ylimits(2) - ylimits(1);

Npoints = size(pathXY,1);
xyDifferences = pathXY- ones(Npoints,1)*currentPointXY;

normalizedDifferences = xyDifferences./[xAxisRange yAxisRange];


distanceFromPointsSquared = sum(normalizedDifferences.^2,2);
[minDistanceSquared,ind] = min(distanceFromPointsSquared,[],1,'omitnan');

% For debugging
if 1==0
    fprintf(1,'%.6f\n',minDistanceSquared);
end

if minDistanceSquared<threshold^2
    closestIndex = ind;
else
    % Leave move index empty if not a click and drag
    closestIndex = [];
end
end

function subPaths = fcn_INTERNAL_splitPathByNaNs(pathXY)
% Splits pathXY into subpaths separated by NaN rows.
%
% Example:
%   [0 0
%    1 0
%    NaN NaN
%    1 1
%    0 1]
%
% becomes:
%   subPaths{1} = [0 0; 1 0]
%   subPaths{2} = [1 1; 0 1]

subPaths = {};

if isempty(pathXY)
    return;
end

nanRows = any(isnan(pathXY),2);

currentSubPath = [];

for ith_row = 1:size(pathXY,1)

    if nanRows(ith_row)
        if ~isempty(currentSubPath)
            subPaths{end+1} = currentSubPath; %#ok<AGROW>
            currentSubPath = [];
        end
    else
        currentSubPath = [currentSubPath; pathXY(ith_row,:)]; %#ok<AGROW>
    end
end

% Add final subpath if it exists
if ~isempty(currentSubPath)
    subPaths{end+1} = currentSubPath;
end

end

function aabbXY = fcn_INTERNAL_buildaabbFromTwoPoints(pathXY)
% Builds an axis-aligned bounding box from two selected corner points.
%
% INPUTS:
%   pathXY - Nx2 array. The first two valid points are used as opposite
%            corners of the aabb.
%
% OUTPUTS:
%   aabbXY - 5x2 array defining the closed aabb outline. If fewer than two
%            valid points are available, the valid clicked points are returned.

% Remove NaN separator rows
validPoints = pathXY(~any(isnan(pathXY),2),:);

if isempty(validPoints)
    aabbXY = [nan nan];
    return;
end

if size(validPoints,1) < 2
    aabbXY = validPoints;
    return;
end

% Use the first two valid points as opposite corners
point1 = validPoints(1,:);
point2 = validPoints(2,:);

% For normal axes, columns are X and Y.
% For geographic axes, columns are latitude/longitude or longitude/latitude
% depending on how the rest of the function stores them. In both cases,
% the aabb is built using column-wise min/max values.
minFirstColumn  = min(point1(1), point2(1));
maxFirstColumn  = max(point1(1), point2(1));
minSecondColumn = min(point1(2), point2(2));
maxSecondColumn = max(point1(2), point2(2));

% Build closed box outline
aabbXY = [
    minFirstColumn  minSecondColumn
    maxFirstColumn  minSecondColumn
    maxFirstColumn  maxSecondColumn
    minFirstColumn  maxSecondColumn
    minFirstColumn  minSecondColumn
    ];

end
function pathXY = fcn_INTERNAL_addPointToOneSidedSegmentPath(pathXY,newPointXY)
% Adds a point to the current one-sided segment subpath.
%
% Each one-sided segment subpath can contain up to two valid points:
% start point and end point. A [NaN NaN] row separates independent segments.
%
% If the current subpath has fewer than two points, the new point is appended.
% If the current subpath already has two points, the second point is replaced.

if isempty(pathXY) || all(isnan(pathXY),'all')
    pathXY = newPointXY;
    return;
end

nanRows = any(isnan(pathXY),2);

% Find the start index of the current subpath after the last NaN row
lastNaNIndex = find(nanRows,1,'last');

if isempty(lastNaNIndex)
    currentSubPathStartIndex = 1;
else
    currentSubPathStartIndex = lastNaNIndex + 1;
end

% If the path ends with NaN, start a new segment
if currentSubPathStartIndex > size(pathXY,1)
    pathXY(end+1,:) = newPointXY;
    return;
end

currentIndices = currentSubPathStartIndex:size(pathXY,1);
currentValidRows = currentIndices(~any(isnan(pathXY(currentIndices,:)),2));

if isempty(currentValidRows)
    pathXY(end+1,:) = newPointXY;

elseif length(currentValidRows) < 2
    pathXY(end+1,:) = newPointXY;

else
    % Replace the second point of the current segment
    pathXY(currentValidRows(2),:) = newPointXY;
end

end


function cleanPathXY = fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath(pathXY)
% Keeps only the first two valid points from each subpath separated by NaNs.
%
% This is used by onesidedsegment mode, where each independent segment is
% defined by two points: start point and end point.

cleanPathXY = [];

if isempty(pathXY)
    cleanPathXY = [nan nan];
    return;
end

subPaths = fcn_INTERNAL_splitPathByNaNs(pathXY);

if isempty(subPaths)
    cleanPathXY = [nan nan];
    return;
end

for ith_subpath = 1:length(subPaths)

    thisSubPath = subPaths{ith_subpath};

    if isempty(thisSubPath)
        continue;
    end

    if size(thisSubPath,1) == 1
        thisCleanSubPath = thisSubPath(1,:);
    else
        thisCleanSubPath = thisSubPath(1:2,:);
    end

    if isempty(cleanPathXY)
        cleanPathXY = thisCleanSubPath;
    else
        cleanPathXY = [cleanPathXY; nan nan; thisCleanSubPath]; %#ok<AGROW>
    end
end

if isempty(cleanPathXY)
    cleanPathXY = [nan nan];
end

end
