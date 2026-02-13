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


ax = gca(figNum); % axes('Parent',h_fig);

% Store state in figure appdata
setappdata(figNum,'HoldPanState',struct('active',false,'startPoint',[0 0],'startXLim',[0 0],'startYLim',[0 0],'button',[]));

if isempty(pathXY)
	pathXY = [nan nan];
end

hPoints = plot(pathXY(:,1), pathXY(:,2), 'r.-','MarkerFaceColor','r','DisplayName','User selected points'); % marker handle

set(h_fig, ...
	'WindowButtonDownFcn', @onClick, ...
	'WindowKeyPressFcn', @onKey, ...
	'WindowButtonMotionFcn', @onMouseMove, ...
	'WindowButtonUpFcn',   @onButtonUp);

title('Click to add points. Right-click to insert a gap. Press (-) to remove prior point. Press Enter to finish.');


uiwait(figNum);    % block until uiresume or figure closed
if ishandle(figNum)
    % close(figNum); % optional: close after finishing
end
	function onClick(~,~)
		if ~ishandle(ax), return; end
		sel = get(h_fig,'SelectionType');    % 'normal' left, 'alt' right, 'open' double
		subtitle(sprintf('Sel: %s',sel));
		if strcmp(sel,'normal')           % only left-clicks add points or pans

			s = getappdata(figNum,'HoldPanState');
			s.active = true;
			s.button = sel;

			% starting data point in axes coordinates
			C = get(ax,'CurrentPoint');
			s.startPoint = C(1,1:2);
			if isprop(ax,'LatitudeAxis') && isprop(ax,'LongitudeAxis')
				[latlimOut,lonlimOut] = geolimits;
				s.startXLim = lonlimOut;
				s.startYLim = latlimOut;
			else
				s.startXLim = ax.XLim;
				s.startYLim = ax.YLim;
			end
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
		C = get (ax, 'CurrentPoint');
		subtitle(['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);

		s = getappdata(figNum,'HoldPanState');
        if ~s.active, return; end
        cur = C(1,1:2);
        dx = cur(1) - s.startPoint(1);
		dy = cur(2) - s.startPoint(2);
		% subtract dx/dy to move view with mouse drag (drag to the right moves view left)
		if isprop(ax,'LatitudeAxis') && isprop(ax,'LongitudeAxis')
			newLongitudeLimits = s.startXLim - dy;
			newLatitudeLimits  = s.startYLim - dx;
			geolimits(newLatitudeLimits,newLongitudeLimits);
		else
			ax.XLim = s.startXLim - dx;
			ax.YLim = s.startYLim - dy;
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

		% Was a click detected
		C = get(ax,'CurrentPoint');
		x = C(1,1);
		y = C(1,2);
		positionChange = [x y] - s.startPoint;
		absChange = norm(positionChange);

		% For debugging
		if 1==0
			fprintf(1,'change was: %.6f\n',absChange);
		end
		
		thresholdChange = eps;
		if absChange<=thresholdChange
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
		if strcmp(event.Key,'return')     % finish on Enter
			uiresume(figNum);

			% disp('Points collected:');
			% disp(pts);
			% uiresume(h_fig);               % optional: resume if waiting
			% close(h_fig);                  % optional: close figure

		elseif strcmp(event.Key,'hyphen')
			if size(pathXY,1)>0
				pathXY(end,:) = [];
			end
			if isempty(pathXY)
				pathXY = [nan nan];
			end
			set(hPoints, 'XData', pathXY(:,1), 'YData', pathXY(:,2));
			drawnow;                      % update immediately
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
if flag_do_plots
	% Nothing to do
       
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); 
end
end







