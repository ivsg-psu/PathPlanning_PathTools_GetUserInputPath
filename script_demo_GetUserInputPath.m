%% Introduction to and Purpose of the Code
% This is the explanation of the code that can be found by running
%
%       script_demo_GetUserInputPath.m
% 
% This is a script to demonstrate the functions within the GetUserInputPath code
% library. This code repo is typically located at:
%
% https://github.com/ivsg-psu/PathPlanning_PathTools_GetUserInputPath
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu
%
% The purpose of the code is to collect points when the user clicks on the
% screen

% REVISION HISTORY:
% 
% 2026_02_12 by Sean Brennan, sbrennan@psu.edu
% - In script_demo_GetUserInputPath
%   % * First creation of the repo in standard form
%   % * Added automatic release check section
%
% (new release)
%
% 2026_02_13 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Updated to support panning with mouse without interrupting point
%   %   capture
%
% (new release)
%
% 2026_03_06 by Sean Brennan, sbrennan@psu.edu
% - In fcn_GetUserInputPath_getUserInputPath
%   % * Updated to support point deletion
%   % * Updated to support point insertion
%   % * Updated to support click-to-drag of points
%   % * Updated to support cling on legend to exit
%   % * Forces close of the figure upon completion
%
% (new release)
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

% TO-DO:
% - 2026_02_12 by Sean Brennan, sbrennan@psu.edu
%   % - Add items here

%% Make sure we are running out of root directory
st = dbstack; 
thisFile = which(st(1).file);
[filepath,name,ext] = fileparts(thisFile);
cd(filepath);

%%% START OF STANDARD INSTALLER CODE %%%%%%%%%

%% Clear paths and folders, if needed
if 1==1
    clear flag_GetUserInputPath_Folders_Initialized
end

if 1==0
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;
end

if 1==0
    % Resets all paths to factory default
    restoredefaultpath;
end

%% Install dependencies
% Define a universal resource locator (URL) pointing to the repos of
% dependencies to install. Note that DebugTools is always installed
% automatically, first, even if not listed:
clear dependencyURLs dependencySubfolders
ith_repo = 0;

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary';
dependencySubfolders{ith_repo} = {'Functions','Data'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad';
dependencySubfolders{ith_repo} = {'Functions','Data'};


% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_MapTools_MapGenClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','testFixtures','GridMapGen'};



%% Do we need to set up the work space?
if ~exist('flag_GetUserInputPath_Folders_Initialized','var')
    
    % Clear prior global variable flags
    clear global FLAG_*

    % Navigate to the Installer directory
    currentFolder = pwd;
    cd('Installer');
    % Create a function handle
    func_handle = @fcn_DebugTools_autoInstallRepos;

    % Return to the original directory
    cd(currentFolder);

    % Call the function to do the install
    func_handle(dependencyURLs, dependencySubfolders, (0), (-1));

    % Add this function's folders to the path
    this_project_folders = {...
        'Functions','Data'};
    fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders)

    flag_GetUserInputPath_Folders_Initialized = 1;
end

%%% END OF STANDARD INSTALLER CODE %%%%%%%%%

%% Set environment flags for input checking in GetUserInputPath library
% These are values to set if we want to check inputs or do debugging
setenv('MATLABFLAG_GETUSERINPUTPATH_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_GETUSERINPUTPATH_FLAG_DO_DEBUG','0');

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions
% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');

%% Check if repo is ready for release
if 1==0
	figNum = 999999;
	repoShortName = '_GetUserInputPath_';
	fcn_DebugTools_testRepoForRelease(repoShortName, (figNum));
end

%% Start of Demo Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____ _             _            __   _____                          _____          _
%  / ____| |           | |          / _| |  __ \                        / ____|        | |
% | (___ | |_ __ _ _ __| |_    ___ | |_  | |  | | ___ _ __ ___   ___   | |     ___   __| | ___
%  \___ \| __/ _` | '__| __|  / _ \|  _| | |  | |/ _ \ '_ ` _ \ / _ \  | |    / _ \ / _` |/ _ \
%  ____) | || (_| | |  | |_  | (_) | |   | |__| |  __/ | | | | | (_) | | |___| (_) | (_| |  __/
% |_____/ \__\__,_|_|   \__|  \___/|_|   |_____/ \___|_| |_| |_|\___/   \_____\___/ \__,_|\___|
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Start%20of%20Demo%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Welcome to the demo code for the GetUserInputPath library!')

%% DEMO case: fcn_GetUserInputPath_getUserInputPath
figNum = 10001;
titleString = sprintf('DEMO case: fcn_GetUserInputPath_getUserInputPath ');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

startingXY = [];
pathXY = fcn_GetUserInputPath_getUserInputPath((startingXY),(figNum));

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

%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

