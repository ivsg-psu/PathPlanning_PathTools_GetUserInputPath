function hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, varargin)
% Updates the drawing based on the selected inputType
%
% FORMAT:
%
%      hPoints = fcn_GetUserInputPath_updateDrawing(pathXY,(inputType), (hPoints), (figNum))
% 
% 
% INPUTS:
%
%      pathXY - XY or LatLon points to use.
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
%      hPoints - a handle to existing plot of the points. If empty, the
%      function creates and returns the handle
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
% See the script: script_test_fcn_GetUserInputPath_updateDrawing
% for a full test suite.
%
% This function was written on 2026_06_08 by S. Brennan by pulling code
% written by Jaime Rodriguez
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: fcn_GetUserInputPath_updateDrawing
%
% 2026_06_08 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_updateDrawing
%   % * Made this function starting with fcn_GetUserInputPath_ +
%   %   % get+UserInputPath


% TO-DO:
% - 2026_06_08 by Sean Brennan, sbrennan@psu.edu
%   % - Add to-do items here


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 4; % The largest Number of argument inputs to the function
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

% Does the user want to specify the hPoints?
hPoints = []; % default
if 3 <= nargin
	temp = varargin{2};
	if ~isempty(temp)
		hPoints = temp;
	end
end

% Does user want to specify the figure number?
flag_do_plots = 1; % Default is to show plots
figNum = []; %#ok<NASGU>
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; %#ok<NASGU>
    end
end

% if isempty(figNum)
% 	temp = figure;
% 	figNum = get(temp,'Number');
% end


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

% For debugging
warning('backtrace','on');

ax = gca;

flag_isGeoPlot = isa(ax,'matlab.graphics.axis.GeographicAxes');
hold(ax, 'on')

if isempty(pathXY)
    pathXY = [nan nan];
end


% Create a plot to start?
if ~iscell(hPoints) && (isempty(hPoints) || ~ishandle(hPoints))
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

            % Convert hPoints into cell array, and create an empty 
            % handle for filled patch objects in patch mode
            temp = hPoints;
            hPoints = cell(2,1);
            hPoints{1} = temp;
            hPoints{2} = gobjects(0);

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

            % Convert hPoints into cell array, and create an empty
            % handle for quiver objects in directedpath mode
            temp = hPoints;
            hPoints = cell(2,1);
            hPoints{1} = temp;
            hPoints{2} = gobjects(0);

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

            % Convert hPoints into cell array, and create an empty
            % handle for quiver objects in onesidedsegment mode
            temp = hPoints;
            hPoints = cell(2,1);
            hPoints{1} = temp;
            hPoints{2} = gobjects(0);

        otherwise
            error('Unknown inputType. Use path, points, patch, aabb, directedpath, or onesidedsegment.');
    end

    if isempty(hPoints) 
        error('hPoints was not created - is empty. Check inputType and drawing object creation.');
    elseif ~iscell(hPoints) && ~isgraphics(hPoints)
        error('hPoints is not a graphics handle. Check inputType and drawing object creation.');
    elseif iscell(hPoints) && ~isgraphics(hPoints{1})
        error('hPoints is a cell array but first value is not a graphics handle. Check inputType and drawing object creation.');
    end
end

% Update the drawing
switch inputType
    case 'path'
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, pathXY);

    case 'points'
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, pathXY);

    case 'patch'
        % Keep NaN rows so right-click can separate different patches
        patchXY = pathXY;

        % Show the clicked points/edges as an editable red line
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, patchXY);

        % Draw the filled patch separately underneath the editable line
        hPoints = fcn_INTERNAL_updatePatchObjects(hPoints, patchXY, flag_isGeoPlot, ax);

    case 'aabb'
        aabbXY = fcn_INTERNAL_buildaabbFromTwoPoints(pathXY);
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, aabbXY);

    case 'directedpath'
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, pathXY);
        hPoints = fcn_INTERNAL_updateDirectedPathObjects(hPoints, pathXY, flag_isGeoPlot, ax);

    case 'onesidedsegment'
        oneSidedSegmentXY = fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath(pathXY);
        hPoints = fcn_INTERNAL_updateLineObject(hPoints, oneSidedSegmentXY);
        hPoints = fcn_INTERNAL_updateOneSidedSegmentObjects(hPoints, oneSidedSegmentXY, flag_isGeoPlot, ax);

    otherwise
        error('Unknown inputType. Use path, points, patch, aabb, directedpath, or onesidedsegment.');
end

drawnow;

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

%% fcn_INTERNAL_updateLineObject
function new_hLine = fcn_INTERNAL_updateLineObject(hLine, displayXY)
% Updates either a normal plot object or a geoplot object.

if iscell(hLine)
    new_hLine = hLine{1};
else
    new_hLine = hLine;    
end

if ~isempty(new_hLine)
    if isprop(new_hLine,'LatitudeData') && isprop(new_hLine,'LongitudeData')
        set(new_hLine, ...
            'LatitudeData', displayXY(:,1), ...
            'LongitudeData', displayXY(:,2));
    else
        set(new_hLine, ...
            'XData', displayXY(:,1), ...
            'YData', displayXY(:,2));
    end
else
    % Create an empty handle
    new_hLine = gobjects(0);
end

% If input is a cell, need to move changes into cell array that was passed
% into the function
if iscell(hLine)
    temp = new_hLine;
    new_hLine = hLine;
    new_hLine{1} = temp;
end

end % Ends fcn_INTERNAL_updateLineObject

%% fcn_INTERNAL_updatePatchObjects
function new_hPoints = fcn_INTERNAL_updatePatchObjects(hPoints, patchXY, flag_isGeoPlot, ax)
% Deletes and redraws separate filled patch objects.
% Each subpath separated by [NaN NaN] becomes its own patch.

new_hPoint = hPoints{1};
hPatchObjects = hPoints{2};

% Delete old patch objects
if ~isempty(hPatchObjects)
    for ith_patch = 1:length(hPatchObjects)
        if isgraphics(hPatchObjects(ith_patch))
            delete(hPatchObjects(ith_patch));
        end
    end
end



% Split into separate patch candidates
subPaths = fcn_INTERNAL_splitPathByNaNs(patchXY);
NsubPaths = length(subPaths);
hPatchObjects = gobjects(NsubPaths,1);
for ith_subpath = 1:NsubPaths

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
                latitudes  = [latitudes; latitudes(1)]; %#ok<AGROW>
                longitudes = [longitudes; longitudes(1)]; %#ok<AGROW>
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

            hPatchObjects(ith_subpath) = geoplot(ax, geoPatchShape, ...
                'FaceColor','red', ...
                'FaceAlpha',0.2, ...
                'EdgeColor','red', ...
                'LineWidth',1.5, ...
                'HandleVisibility','off');

        else
            % Normal XY axes case
            hPatchObjects(ith_subpath) = patch('XData',thisPatchXY(:,1), ...
                'YData',thisPatchXY(:,2), ...
                'FaceColor','red', ...
                'FaceAlpha',0.2, ...
                'EdgeColor','red', ...
                'LineWidth',1.5, ...
                'HitTest','off', ...
                'PickableParts','none', ...
                'HandleVisibility','off'); 
        end
    end
end

new_hPoints{1} = new_hPoint;
new_hPoints{2} = hPatchObjects;

% Keep clicked points/line above filled patches
if isgraphics(new_hPoint)
    uistack(new_hPoint,'top');
end
end % Ends fcn_INTERNAL_updatePatchObjects

%% fcn_INTERNAL_updateDirectedPathObjects
function new_hPoints = fcn_INTERNAL_updateDirectedPathObjects(hPoints, directedPathXY, flag_isGeoPlot, ax)
% Draws arrows between consecutive valid points in directed path mode.
%
% In normal XY axes, arrows are drawn using quiver.
% In GeographicAxes, arrows are drawn manually using geoplot because
% quiver is not compatible with GeographicAxes in the same way.
new_hPoint = hPoints{1};
hQuiverObjects = hPoints{2};
hQuiverObjects = fcn_INTERNAL_deleteQuiverObjects(hQuiverObjects);

subPaths = fcn_INTERNAL_splitPathByNaNs(directedPathXY);
NsubPaths = length(subPaths);

for ith_subpath = 1:NsubPaths

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
                hQuiverObjects(ith_subpath) = geoplot(ax, ...
                    [latStart latEnd], ...
                    [lonStart lonEnd], ...
                    'r-', ...
                    'LineWidth',1.5, ...
                    'HandleVisibility','off'); 

                % Draw arrow head
                hQuiverObjects(ith_subpath) = geoplot(ax, ...
                    [latLeft latEnd latRight], ...
                    [lonLeft lonEnd lonRight], ...
                    'r-', ...
                    'LineWidth',1.5, ...
                    'HandleVisibility','off'); 
            end

        else

            % Normal XY axes case
            xStart = thisPathXY(1:end-1,1);
            yStart = thisPathXY(1:end-1,2);

            dx = thisPathXY(2:end,1) - thisPathXY(1:end-1,1);
            dy = thisPathXY(2:end,2) - thisPathXY(1:end-1,2);

            hQuiverObjects(ith_subpath) = quiver(ax, ...
                xStart, yStart, dx, dy, ...
                0, ...
                'Color','r', ...
                'LineWidth',1.5, ...
                'MaxHeadSize',0.5, ...
                'HandleVisibility','off'); 
        end
    end
end

new_hPoints{1} = new_hPoint;
new_hPoints{2} = hQuiverObjects;

if isgraphics(new_hPoint)
    uistack(new_hPoint,'top');
end
end % Ends fcn_INTERNAL_updateDirectedPathObjects

%% fcn_INTERNAL_deleteQuiverObjects
function hQuiverObjects = fcn_INTERNAL_deleteQuiverObjects(hQuiverObjects)
% Deletes old quiver objects used by directed path and one-sided segment modes.

if ~isempty(hQuiverObjects)
    for ith_quiver = 1:length(hQuiverObjects)
        if isgraphics(hQuiverObjects(ith_quiver))
            delete(hQuiverObjects(ith_quiver));
        end
    end
end

hQuiverObjects = gobjects(0);
end  % Ends fcn_INTERNAL_deleteQuiverObjects


%% fcn_INTERNAL_updateOneSidedSegmentObjects
function new_hPoints = fcn_INTERNAL_updateOneSidedSegmentObjects(hPoints, segmentXY, flag_isGeoPlot, ax)
% Draws a perpendicular arrow showing the positive side of each segment.
% The positive side is the left side when moving from start point to end point.

new_hPoint = hPoints{1};
hQuiverObjects = hPoints{2};
hQuiverObjects = fcn_INTERNAL_deleteQuiverObjects(hQuiverObjects);

subPaths = fcn_INTERNAL_splitPathByNaNs(segmentXY);
NsubPaths = length(subPaths);
for ith_subpath = 1:NsubPaths

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
        hQuiverObjects(ith_subpath) = geoplot(ax, ...
            [latHeadLeft latHeadTip], ...
            [lonHeadLeft lonHeadTip], ...
            'r-', ...
            'LineWidth',4, ...
            'HandleVisibility','off'); 

        % Draw arrow head right side
        hQuiverObjects(ith_subpath) = geoplot(ax, ...
            [latHeadRight latHeadTip], ...
            [lonHeadRight lonHeadTip], ...
            'r-', ...
            'LineWidth',4, ...
            'HandleVisibility','off'); 

    else

        % Normal XY axes case
        hQuiverObjects(ith_subpath) = quiver(ax, ...
            midPoint(1), midPoint(2), ...
            arrowLength*normalVector(1), arrowLength*normalVector(2), ...
            0, ...
            'Color','r', ...
            'LineWidth',3, ...
            'MaxHeadSize',1.5, ...
            'HandleVisibility','off'); 
    end
end

new_hPoints{1} = new_hPoint;
new_hPoints{2} = hQuiverObjects;

if isgraphics(new_hPoint)
    uistack(new_hPoint,'top');
end
end % Ends fcn_INTERNAL_updateOneSidedSegmentObjects

%% fcn_INTERNAL_splitPathByNaNs
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

end % Ends fcn_INTERNAL_splitPathByNaNs

%% fcn_INTERNAL_buildaabbFromTwoPoints
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
point1 = min(validPoints, [],1);
point2 = max(validPoints, [],1);

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

end % Ends fcn_INTERNAL_buildaabbFromTwoPoints

%% fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath
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

end % Ends fcn_INTERNAL_keepFirstTwoValidPointsPerSubPath