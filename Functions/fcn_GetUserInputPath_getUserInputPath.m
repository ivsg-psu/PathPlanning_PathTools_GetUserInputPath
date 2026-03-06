function pathXY = fcn_GetUserInputPath_getUserInputPath(varargin)
% fcn_GetUserInputPath_getUserInputPath
% A function for the user to click on the figure to generate XY path until
% the user hits the "return" key. If the user right-clicks, it inserts a
% [nan nan] row which effectively creates a gap in the plot. If the user
% hits the "minus" or hyphen key, it removes the most recent point.
%
% As an optional input, the function can start with a startingXY point
% list, plotting this first.
%
% FORMAT:
%
%      pathXY = fcn_GetUserInputPath_getUserInputPath((startingXY),(figNum))
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
% OUTPUTS:
%      pathXY: matrix (Nx2) representing the X and Y points that the user
%      clicked on the map
%
% EXAMPLES:
%
%      % BASIC example
%      pathXY = fcn_GetUserInputPath_getUserInputPath
%
% See the script: script_test_fcn_GetUserInputPath_getUserInputPath
% for a full test suite.
%
% This function was written on 2020_10_15 by S. Brennan
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

% TO-DO:
% - 2026_02_12 by Sean Brennan, sbrennan@psu.edu
%   % - Add motion blur model, maybe?


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 2; % The largest Number of argument inputs to the function
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
if 1 <= nargin
	temp = varargin{1};
	if ~isempty(temp)
		pathXY = temp;
	end
end

% % Does the user want to specify the cornerShape?
% cornerParams = [L/5 W/10]; % Default case
% if 4 <= nargin
%     temp = varargin{2};
%     if ~isempty(temp)
% 		cornerParams = temp;
%     end
% end
%
% % Does the user want to specify the NcornerPoints?
% NcornerPoints = 20; % Default case
% if 5 <= nargin
%     temp = varargin{3};
%     if ~isempty(temp)
% 		NcornerPoints = temp;
% 		validateattributes(NcornerPoints,{'numeric'},{'scalar','integer','>=',2});
%     end
% end

% Does user want to show the plots?
flag_do_plots = 1; % Default is to show plots
figNum = [];
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
	temp = varargin{end};
	if ~isempty(temp) % Did the user NOT give an empty figure number?
		figNum = temp;
		flag_do_plots = 1;
	end
end

if isempty(figNum)
	temp = figure;
	figNum = get(temp,'Number');
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
hPoints = plot(pathXY(:,1), pathXY(:,2), 'r.-','MarkerFaceColor','r','DisplayName','User selected points'); % marker handle


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

title({'Click to add points. Right-click to inserts gap. Click-drag to shift point or move axis.','(-) removes prior point. (d) deletes closest point. (i) inserts point. Press Enter to finish.'});


uiwait(figNum);    % block until uiresume or figure closed
if ishandle(figNum)
	% close(figNum); % optional: close after finishing
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
			set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
			drawnow;                      % update immediately
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

			set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
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
			set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
		end
		drawnow;                      % update immediately
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

			case 'hyphen' % Removes the last point
				if size(pathXY,1)>0
					pathXY(end,:) = [];
				end
				if isempty(pathXY)
					pathXY = [nan nan];
				end
				set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
				drawnow;                      % update immediately

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

				set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
				drawnow;                      % update immediately



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

				set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
				drawnow;                      % update immediately

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