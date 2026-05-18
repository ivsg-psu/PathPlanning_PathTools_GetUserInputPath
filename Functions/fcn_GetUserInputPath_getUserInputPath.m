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
% If the user right-clicks, the function inserts a [nan nan] row, which
% effectively creates a gap in the plotted path. If the user hits the
% "minus" or hyphen key, it removes the most recent point.
%
% In 'path' mode, pressing the 'c' key toggles a visual closure of separated
% subpaths by connecting nearest available free endpoints. This closure does
% not modify the returned pathXY. If requested as a second output, the closed
% boundary is returned as closedAreaXY.
%
% As an optional input, the function can start with a startingXY point
% list, plotting this first.
%
% FORMAT:
%
%      [pathXY, closedAreaXY] = fcn_GetUserInputPath_getUserInputPath((startingXY),(figNum),(inputType),(patchCloseMode))
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
%
%      patchCloseMode - string specifying how patch points are ordered before
%                       drawing. Options are:
%                       'ordered' - default. Uses the user click order and
%                                   closes the patch by connecting the last
%                                   point back to the first point.
%
%                       'nearest_free_endpoint' - Should separate the input into
%                                   subpaths using [nan nan] rows and orders
%                                   the subpaths by connecting the nearest
%                                   available free endpoints.
%

% OUTPUTS:
%      pathXY: matrix (Nx2) representing the X and Y points that the user
%      clicked on the map.
%
%      closedAreaXY: matrix (Mx2) representing the closed area generated
%      from path subpaths when the user presses the 'c' key in path mode.
%      This output is empty if no closed area is generated.
%
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
%      % Example using patch mode with ordered point connection
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'patch', 'ordered')
%
%      % Example using patch mode with nearest free endpoint ordering
%      pathXY = fcn_GetUserInputPath_getUserInputPath([], figNum, 'patch', 'nearest_free_endpoint')
%
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
%   % * Added 'patch' mode, where user-selected points are displayed as a
%   %   closed patch.
%   % * Updated patch display behavior so that, when fewer than 3 valid
%   %   points are available, the selected points are displayed like a path
%   %   instead of an empty patch.
%   % * Added patchCloseMode optional argument to control patch point ordering.
%   % * Added 'ordered' patch close mode, where patch points follow the user
%   %   click order and the last point is connected back to the first point.
%   % * Added 'nearest_free_endpoint' patch close mode, where paths separated
%   %   by [nan nan] rows are ordered by connecting nearest available free
%   %   endpoints.
%   % * Added fcn_INTERNAL_buildPatchPoints helper function to prepare patch
%   %   display points.
%   % * Added fcn_INTERNAL_splitPathByNaNs helper function to split user input
%   %   paths into subpaths separated by [nan nan] rows.
%   % * Added updateDrawing internal function to centralize display updates
%   %   across path, points, and patch modes.
%   % * Added manual axis-limit mode after creating the drawing object to help
%   %   prevent MATLAB from auto-zooming when points are added.
%   % * Added 'c' key command in path mode to visually close separated
%   %   subpaths by connecting nearest available free endpoints without
%   %   modifying the returned pathXY.


% TO-DO:
% - 2026_02_12 by Sean Brennan, sbrennan@psu.edu
%   % - Add motion blur model, maybe?


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
inputType = 'path'; % default
if 3 <= nargin
	temp = varargin{3};
	if ~isempty(temp)
		inputType = lower(temp);
	end
end

validInputTypes = {'path','points','patch'};
if ~any(strcmp(inputType,validInputTypes))
	error('inputType must be one of: path, points, or patch');
end

% Does the user want to specify how patches are closed?
% Options:
%   'ordered'               - connect points in click order and close last to first
%   'nearest_free_endpoint' - connect open/free endpoints between subpaths
patchCloseMode = 'ordered'; % default
if 4 <= nargin
	temp = varargin{4};
	if ~isempty(temp)
		patchCloseMode = lower(temp);
	end
end

validPatchCloseModes = {'ordered','nearest_free_endpoint'};
if ~any(strcmp(patchCloseMode,validPatchCloseModes))
	error('patchCloseMode must be one of: ordered or nearest_free_endpoint');
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
flag_closePathByFreeEndpoints = false;

h_fig = figure(figNum);

% For debuggin
warning('backtrace','on');

ax = gca(figNum); % axes('Parent',h_fig);

flag_isGeoPlot = 0;
if isprop(ax,'LatitudeAxis') && isprop(ax,'LongitudeAxis')
	flag_isGeoPlot = 1;
end

% Store state in figure appdata
setappdata(figNum,'HoldPanState',struct('active',false,'startPoint',[0 0],'startXLim',[0 0],'startYLim',[0 0],'button',[],'legendClicked',false));

if isempty(pathXY)
	pathXY = [nan nan];
end


% Create a plot
% Create the user input drawing object
switch inputType
	case 'path'
		hPoints = plot(pathXY(:,1), pathXY(:,2), ...
			'r.-', ...
			'MarkerFaceColor','r', ...
			'DisplayName','User selected path');

	case 'points'
		hPoints = plot(pathXY(:,1), pathXY(:,2), ...
			'r.', ...
			'MarkerSize',20, ...
			'DisplayName','User selected points');

	case 'patch'
		hPoints = patch('XData',pathXY(:,1), ...
			'YData',pathXY(:,2), ...
			'FaceColor','red', ...
			'FaceAlpha',0.2, ...
			'EdgeColor','red', ...
			'LineWidth',1.5, ...
			'Marker','.', ...
			'MarkerFaceColor','red', ...
			'DisplayName','User selected patch');

	otherwise
		error('Unknown inputType. Use path, points, or patch.');
end
% Freeze the axis limits so MATLAB does not auto-zoom when points are added
if flag_isGeoPlot
	[fixedLatLim, fixedLonLim] = geolimits;
else
	fixedXLim = ax.XLim;
	fixedYLim = ax.YLim;
	ax.XLimMode = 'manual';
	ax.YLimMode = 'manual';
end

% Create the "exit" patch
if flag_isGeoPlot
	laneShape = geopolyshape(nan, nan);
	geoplot(laneShape,'FaceColor',[0 0 1],'DisplayName','Click Here To Exit')
else
	patch('Xdata',nan, 'YData',nan,'FaceColor',[0 0 1],'DisplayName','Click Here To Exit')
end


h_legend = legend('Interpreter','none','Location','northeast');

% Set ItemHitFcn
h_legend.ItemHitFcn = @(src,event) legendItemClicked(src,event);

set(h_fig, ...
	'WindowButtonDownFcn', @onClick, ...
	'WindowKeyPressFcn', @onKey, ...
	'WindowButtonMotionFcn', @onMouseMove, ...
	'WindowButtonUpFcn',   @onButtonUp);

title({'Click to add points. Right-click inserts gap. Click-drag shifts point or moves axis.', ...
	'(-) removes prior point. (d) deletes closest point. (i) inserts point. (c) closes path. Press Enter to finish.'});

uiwait(figNum);    % block until uiresume or figure closed
if ishandle(figNum)
	% close(figNum); % optional: close after finishing
end
	function updateDrawing()
		% Updates the drawing based on the selected inputType

		switch inputType
            case 'path'
	if flag_closePathByFreeEndpoints && ~isempty(closedAreaXY) && size(closedAreaXY,1) >= 3
		% Display the stored closed area as a closed outline
		displayXY = [
			closedAreaXY
			closedAreaXY(1,:)
		];
	else
		displayXY = pathXY;
	end

	set(hPoints, ...
		'XData', displayXY(:,1), ...
		'YData', displayXY(:,2));

			case 'points'
				set(hPoints, ...
					'XData', pathXY(:,1), ...
					'YData', pathXY(:,2));

			case 'patch'
	patchXY = fcn_INTERNAL_buildPatchPoints(pathXY, patchCloseMode);

	if size(patchXY,1) >= 3
		set(hPoints, ...
			'XData', patchXY(:,1), ...
			'YData', patchXY(:,2), ...
			'FaceAlpha',0.2, ...
			'LineStyle','-', ...
			'Marker','.');
	else
		% With fewer than 3 valid points, display the selected points
		% like a path so the user can see what is being clicked.
		set(hPoints, ...
			'XData', patchXY(:,1), ...
			'YData', patchXY(:,2), ...
			'FaceAlpha',0, ...
			'LineStyle','-', ...
			'Marker','.');
    end
        end

		drawnow;
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

		if ~ishandle(ax), return; end

		sel = get(h_fig,'SelectionType');    % 'normal' left, 'alt' right, 'open' double
		subtitle(sprintf('Sel: %s',sel));


		if strcmp(sel,'normal')           % only left-clicks add points or pans

			s = getappdata(figNum,'HoldPanState');
			s.active = true;
			s.button = sel;

			% starting data point in axes coordinates
			currentPoint = get(ax,'CurrentPoint');
			currentPointXY = currentPoint(1,1:2);
			s.startPoint = currentPoint(1,1:2);


			% Get current axis limits
			if flag_isGeoPlot
				[latlimOut,lonlimOut] = geolimits;
				s.startXLim = lonlimOut;
				s.startYLim = latlimOut;
			else
				s.startXLim = ax.XLim;
				s.startYLim = ax.YLim;
			end

			%%%%%%%%%%%%%
			% FORMAT:
			% closestIndex = fcn_INTERNAL_findNearestPointIndex(xlimits, ylimits, pathXY, currentPointXY, threshold)
			closestIndex = fcn_INTERNAL_findNearestPointIndex(s.startXLim, s.startYLim, pathXY, currentPointXY, 0.01);
			s.MoveIndex = closestIndex;

			% Save current axis limits
			setappdata(figNum,'HoldPanState',s);

			% enable motion callback
			set(figNum,'WindowButtonMotionFcn',@onMouseMove);

		elseif strcmp(sel,'alt')
			pathXY(end+1,:) = [nan nan];         % append nan
			updateDrawing();                      % update immediately
		else
			% fprintf(1,'State is: %s\n',sel);
			return;
		end
	end

	function onMouseMove(~,~)
		currentPoint = get (ax, 'CurrentPoint');
		subtitle(['(X,Y) = (', num2str(currentPoint(1,1)), ', ',num2str(currentPoint(1,2)), ')']);

		s = getappdata(figNum,'HoldPanState');

		% Check to see if mouse is down (active). If not, do nothing.
		if ~s.active, return; end

		currentPointXY = currentPoint(1,1:2);
		if isempty(s.MoveIndex)

			% Must be in pan mode
			dx = currentPointXY(1) - s.startPoint(1);
			dy = currentPointXY(2) - s.startPoint(2);


			% subtract dx/dy to move view with mouse drag (drag to the right moves view left)
			if flag_isGeoPlot
				newLongitudeLimits = s.startXLim - dy;
				newLatitudeLimits  = s.startYLim - dx;
				geolimits(newLatitudeLimits,newLongitudeLimits);
			else
				ax.XLim = s.startXLim - dx;
				ax.YLim = s.startYLim - dy;
			end
		else
			% Must be in move point mode

			% Constrain within axis limits
			xl = s.startXLim;
			yl = s.startYLim;

			if flag_isGeoPlot
				newx = max(min(currentPointXY(1,2),xl(2)),xl(1));
				newy = max(min(currentPointXY(1,1),yl(2)),yl(1));
				pathXY(s.MoveIndex,:) = [newy newx];
			else
				newx = max(min(currentPointXY(1,1),xl(2)),xl(1));
				newy = max(min(currentPointXY(1,2),yl(2)),yl(1));
				pathXY(s.MoveIndex,:) = [newx newy];
			end

			updateDrawing();
		end

		drawnow limitrate;
	end

	function onButtonUp(~,~)
		s = getappdata(figNum,'HoldPanState');
		if s.active
			s.active = false;
			setappdata(figNum,'HoldPanState',s);
			% set(figNum,'WindowButtonMotionFcn',[]); % disable motion callback
		end

		if s.legendClicked
			% Register the legend was clicked, and then do nothing
			s.legendClicked = false;
			setappdata(figNum,'HoldPanState',s);
			return;
		end


		% Was a click detected? Compare current point to previous point to
		% see if there was a change
		currentPoint = get(ax,'CurrentPoint');
		x = currentPoint(1,1);
		y = currentPoint(1,2);
		positionChange = [x y] - s.startPoint;
		absChange = norm(positionChange);

		% For debugging
		if 1==0
			fprintf(1,'change was: %.6f\n',absChange);
		end


		thresholdChange = eps;
		if absChange<=thresholdChange
			% If enter here, a click was detected
			if all(isnan(pathXY),'all')
				pathXY(1,:) = [x, y];
			else
				pathXY(end+1,:) = [x y];         % append
			end
			updateDrawing();
		end
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

        	case 'c' % Toggle closing path using nearest free endpoints
	if strcmp(inputType,'path')

		flag_closePathByFreeEndpoints = ~flag_closePathByFreeEndpoints;

		if flag_closePathByFreeEndpoints
			% Build and store the closed area from separated subpaths
			closedAreaXY = fcn_INTERNAL_buildClosedAreaFromPath(pathXY);

			if size(closedAreaXY,1) < 3
				fprintf(1,'Not enough valid points to create a closed area.\n');
				closedAreaXY = [];
				flag_closePathByFreeEndpoints = false;
			else
				fprintf(1,'Path free-endpoint closure is ON. closedAreaXY has been updated.\n');
			end
		else
			closedAreaXY = [];
			fprintf(1,'Path free-endpoint closure is OFF. closedAreaXY has been cleared.\n');
		end

		updateDrawing();

	else
		fprintf(1,'Close command is only active in path mode.\n');
	end

			case 'hyphen' % Removes the last point
				if size(pathXY,1)>0
					pathXY(end,:) = [];
				end
				if isempty(pathXY)
					pathXY = [nan nan];
				end
				updateDrawing();                    % update immediately

			case 'i'     % Insert a new point

				% Find closest point
				currentPoint = get (ax, 'CurrentPoint');
				currentPointXY = currentPoint(1,1:2);

				if size(pathXY,1)==0
					pathXY = currentPointXY;
				else
					% Break path up into cell arrays, because snap function
					% does not work if there are NaN values
					cellArrayOfSubPathIndices = fcn_DebugTools_breakArrayByNans(pathXY,-1);

					% Loop through subpaths to see if they have closest
					% distance
					nearestDistance = inf;
					first_path_point_index = 1;
					second_path_point_index = 1;
					flag_isStartOrEnd = 0;
					for ith_subpath = 1:length(cellArrayOfSubPathIndices)
						thisIndices = cellArrayOfSubPathIndices{ith_subpath};
						thisSubPath = pathXY(thisIndices,:);

						% Keep track of which index the subpath starts at.
						% The snap function returns indices relative to the
						% subpath, NOT to pathXY
						thisOffsetIndex = thisIndices(1);

						% Snap point onto nearest path segment
						% FORMAT:
						% [closest_path_point,s_coordinate,path_point_yaw,....
						% 	first_path_point_index,...
						% 	second_path_point_index,...
						% 	percent_along_length] = ...
						% 	fcn_Path_snapPointOntoNearestPath(point, path, varargin)
						[closest_path_point,~,~,....
							this_first_path_point_index,...
							this_second_path_point_index,...
							~] = fcn_Path_snapPointOntoNearestPath(currentPointXY, thisSubPath, -1);
						thisDistance = sum((closest_path_point-currentPointXY).^2,2);

						% Check to see if this snap point is the closest
						if thisDistance < nearestDistance
							nearestDistance = thisDistance;
							first_path_point_index = this_first_path_point_index + thisOffsetIndex-1;
							second_path_point_index = this_second_path_point_index + thisOffsetIndex-1;

							% Check for special case where insertion has to
							% be done at one of the endpoints of the
							% subsegments
							flag_isStartOrEnd = 0;
							if this_first_path_point_index==this_second_path_point_index
								if this_first_path_point_index==1
									flag_isStartOrEnd = -1;
								else
									flag_isStartOrEnd = 1;
								end
							end

						end
					end

					% Perform insertion
					if first_path_point_index==second_path_point_index
						% The only time code will enter here is if an added
						% path point was found to occur either at the very
						% start or very end of the entire pathXY or one of
						% the subsegments. The insertion changes depending
						% on which case is encountered.
						if first_path_point_index == 1
							% Insert at very front
							pathXY = [currentPointXY; pathXY];
						elseif first_path_point_index == size(pathXY,1)
							% Insert at very end
							pathXY = [pathXY; currentPointXY];
						elseif flag_isStartOrEnd== -1
							% Insert at front of subsegment but not very front
							pathXY = [pathXY(1:first_path_point_index-1,:); currentPointXY; pathXY(first_path_point_index:end,:)];
						else
							% Insert at end of subsegment but not very end
							pathXY = [pathXY(1:first_path_point_index,:); currentPointXY; pathXY(first_path_point_index+1:end,:)];
						end
					else
						% Insert between end points
						pathXY = [pathXY(1:first_path_point_index,:); currentPointXY; pathXY(second_path_point_index:end,:)];
					end
				end

				updateDrawing();                     % update immediately



			case 'd' % Delete a point
				if size(pathXY,1)<2
					pathXY = [nan nan];
					return;
				end

				% Find closest point
				currentPoint = get (ax, 'CurrentPoint');
				currentPointXY = currentPoint(1,1:2);

				% Get current axis limits
				s = getappdata(figNum,'HoldPanState');
				if flag_isGeoPlot
					[latlimOut,lonlimOut] = geolimits;
					s.startXLim = lonlimOut;
					s.startYLim = latlimOut;
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
				fprintf(1,'No action coded for keypress: %s\n',keyPress);
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
close(figNum);

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

function patchXY = fcn_INTERNAL_buildPatchPoints(pathXY, patchCloseMode)
% Builds the point order used to draw a patch.
%
% INPUTS:
%   pathXY - Nx2 array of points. NaN rows separate open subpaths.
%   patchCloseMode - either:
%       'ordered'
%       'nearest_free_endpoint'
%
% OUTPUTS:
%   patchXY - ordered points to send to MATLAB patch

% Remove completely empty case
if isempty(pathXY)
	patchXY = [];
	return;
end

% Remove rows that are all NaN for ordered mode
switch patchCloseMode
	case 'ordered'
		patchXY = pathXY(~any(isnan(pathXY),2),:);

	case 'nearest_free_endpoint'
		subPaths = fcn_INTERNAL_splitPathByNaNs(pathXY);

		if isempty(subPaths)
			patchXY = [];
			return;
		end

		% Start with the first available subpath
		patchXY = subPaths{1};
		subPaths(1) = [];

		% Keep connecting the current free endpoint to the nearest
		% free endpoint of any remaining subpath.
		while ~isempty(subPaths)

			currentEndPoint = patchXY(end,:);

			bestDistanceSquared = inf;
			bestSubPathIndex = 1;
			bestOrientation = 'forward';

			for ith_subpath = 1:length(subPaths)
				thisSubPath = subPaths{ith_subpath};

				thisStartPoint = thisSubPath(1,:);
				thisEndPoint   = thisSubPath(end,:);

				distanceToStartSquared = sum((currentEndPoint - thisStartPoint).^2);
				distanceToEndSquared   = sum((currentEndPoint - thisEndPoint).^2);

				if distanceToStartSquared < bestDistanceSquared
					bestDistanceSquared = distanceToStartSquared;
					bestSubPathIndex = ith_subpath;
					bestOrientation = 'forward';
				end

				if distanceToEndSquared < bestDistanceSquared
					bestDistanceSquared = distanceToEndSquared;
					bestSubPathIndex = ith_subpath;
					bestOrientation = 'reverse';
				end
			end

			% Add the best matching subpath in the correct orientation
			bestSubPath = subPaths{bestSubPathIndex};

			if strcmp(bestOrientation,'forward')
				patchXY = [patchXY; bestSubPath];
			else
				patchXY = [patchXY; flipud(bestSubPath)];
			end

			% Remove the subpath that was just used
			subPaths(bestSubPathIndex) = [];
		end

	otherwise
		error('Unknown patchCloseMode.');
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

function displayXY = fcn_INTERNAL_buildClosedPathDisplayPoints(pathXY, flag_closePathByFreeEndpoints)
% Builds display points for path mode.
%
% If flag_closePathByFreeEndpoints is false:
%   displayXY = pathXY
%
% If flag_closePathByFreeEndpoints is true:
%   the function detects free endpoints of subpaths separated by [nan nan]
%   rows and connects the closest endpoint pairs. Each endpoint is used
%   only once. Connections are only made between different subpaths.
%
% This function does not modify the original pathXY.

if isempty(pathXY)
	displayXY = pathXY;
	return;
end

% If closure is off, display the original path exactly as stored
if ~flag_closePathByFreeEndpoints
	displayXY = pathXY;
	return;
end

% Split path into subpaths separated by NaN rows
subPaths = fcn_INTERNAL_splitPathByNaNs(pathXY);

if isempty(subPaths)
	displayXY = pathXY;
	return;
end

% Start by drawing the original path exactly as stored
displayXY = pathXY;

% Collect free endpoints.
% Each subpath contributes two free endpoints:
%   - first point
%   - last point
freeEndpoints = [];
endpointSubPathIndex = [];

for ith_subpath = 1:length(subPaths)

	thisSubPath = subPaths{ith_subpath};

	if isempty(thisSubPath)
		continue;
	end

	% First endpoint of this subpath
	freeEndpoints = [
		freeEndpoints
		thisSubPath(1,:)
	];

	endpointSubPathIndex = [
		endpointSubPathIndex
		ith_subpath
	];

	% Last endpoint of this subpath
	freeEndpoints = [
		freeEndpoints
		thisSubPath(end,:)
	];

	endpointSubPathIndex = [
		endpointSubPathIndex
		ith_subpath
	];
end

Nendpoints = size(freeEndpoints,1);

% If fewer than 2 free endpoints exist, no connection can be made
if Nendpoints < 2
	return;
end

usedEndpoint = false(Nendpoints,1);
closureSegments = [];

while sum(~usedEndpoint) >= 2

	bestDistanceSquared = inf;
	best_i = [];
	best_j = [];

	for i = 1:Nendpoints

		if usedEndpoint(i)
			continue;
		end

		for j = i+1:Nendpoints

			if usedEndpoint(j)
				continue;
			end

			% Do not connect endpoints from the same subpath.
			% This prevents closing each individual subpath by itself.
			if endpointSubPathIndex(i) == endpointSubPathIndex(j)
				continue;
			end

			thisDistanceSquared = sum((freeEndpoints(i,:) - freeEndpoints(j,:)).^2);

			if thisDistanceSquared < bestDistanceSquared
				bestDistanceSquared = thisDistanceSquared;
				best_i = i;
				best_j = j;
			end
		end
	end

	% If no valid pair was found, stop
	if isempty(best_i) || isempty(best_j)
		break;
	end

	% Add one visual connection segment.
	% NaN NaN prevents MATLAB from connecting this segment to unrelated
	% previous points.
	closureSegments = [
		closureSegments
		NaN NaN
		freeEndpoints(best_i,:)
		freeEndpoints(best_j,:)
	];

	% Mark both endpoints as used so each one is connected only once
	usedEndpoint(best_i) = true;
	usedEndpoint(best_j) = true;
end

% Add visual closure segments to the original display path
displayXY = [
	displayXY
	closureSegments
];

end

function closedAreaXY = fcn_INTERNAL_buildClosedAreaFromPath(pathXY)
% Builds a closed area from path subpaths separated by NaN rows.
%
% The function connects nearest available free endpoints between different
% subpaths and returns an ordered closed boundary.
%
% This does not modify the original pathXY.

closedAreaXY = [];

if isempty(pathXY)
	return;
end

% Split path into subpaths separated by NaN rows
subPaths = fcn_INTERNAL_splitPathByNaNs(pathXY);

if isempty(subPaths)
	return;
end

% If there is only one subpath, use it directly if it has enough points.
% It will be visually closed by repeating the first point during plotting.
if length(subPaths) == 1
	thisSubPath = subPaths{1};

	if size(thisSubPath,1) >= 3
		closedAreaXY = thisSubPath;
	end

	return;
end

% Special case: two subpaths.
% This is the most common case for closing an area from two open boundaries.
if length(subPaths) == 2
	pathA = subPaths{1};
	pathB = subPaths{2};

	A_start = pathA(1,:);
	A_end   = pathA(end,:);

	B_start = pathB(1,:);
	B_end   = pathB(end,:);

	% Option 1:
	% pathA followed by pathB
	% closure distances: A_end -> B_start and B_end -> A_start
	totalDistance_forward = ...
		sum((A_end - B_start).^2) + ...
		sum((B_end - A_start).^2);

	% Option 2:
	% pathA followed by reversed pathB
	% closure distances: A_end -> B_end and B_start -> A_start
	totalDistance_reverse = ...
		sum((A_end - B_end).^2) + ...
		sum((B_start - A_start).^2);

	if totalDistance_forward <= totalDistance_reverse
		closedAreaXY = [pathA; pathB];
	else
		closedAreaXY = [pathA; flipud(pathB)];
	end

	return;
end

% General case: more than two subpaths.
% Greedily append the subpath whose free endpoint is closest to the current
% end point.
closedAreaXY = subPaths{1};
subPaths(1) = [];

while ~isempty(subPaths)

	currentEndPoint = closedAreaXY(end,:);

	bestDistanceSquared = inf;
	bestSubPathIndex = [];
	bestOrientation = 'forward';

	for ith_subpath = 1:length(subPaths)

		thisSubPath = subPaths{ith_subpath};

		thisStart = thisSubPath(1,:);
		thisEnd   = thisSubPath(end,:);

		distanceToStart = sum((currentEndPoint - thisStart).^2);
		distanceToEnd   = sum((currentEndPoint - thisEnd).^2);

		if distanceToStart < bestDistanceSquared
			bestDistanceSquared = distanceToStart;
			bestSubPathIndex = ith_subpath;
			bestOrientation = 'forward';
		end

		if distanceToEnd < bestDistanceSquared
			bestDistanceSquared = distanceToEnd;
			bestSubPathIndex = ith_subpath;
			bestOrientation = 'reverse';
		end
	end

	bestSubPath = subPaths{bestSubPathIndex};

	if strcmp(bestOrientation,'forward')
		closedAreaXY = [closedAreaXY; bestSubPath];
	else
		closedAreaXY = [closedAreaXY; flipud(bestSubPath)];
	end

	subPaths(bestSubPathIndex) = [];
end

end