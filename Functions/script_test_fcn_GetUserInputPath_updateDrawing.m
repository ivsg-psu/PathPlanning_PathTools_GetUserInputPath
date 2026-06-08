% script_test_fcn_GetUserInputPath_updateDrawing
% This is a script to exercise the function:
% fcn_GetUserInputPath_updateDrawing.m
%
% This script was written on 2026_06_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: script_test_fcn_GetUserInputPath_updateDrawing
%
% 2026_06_08 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_GetUserInputPath_updateDrawing
%   % * Wrote the code originally 
%   % * Using script_test_fcn_GetUserInputPath_ + getUserInputPath
%   %   % as a starter

% TO-DO:
%
% 2026_06_08 by Jaime Rodriguez
% - In script_test_fcn_GetUserInputPath_updateDrawing

%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases - all are interactive so commented out\n');

%% DEMO case: empty data and empty inputType example
figNum = 10001;
titleString = sprintf('DEMO case: empty data and empty inputType example');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [];
inputType = '';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and empty inputType - defaults to path
figNum = 10002;
titleString = sprintf('DEMO case: non-empty data and empty inputType - defaults to path');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [1 2; 3 4];
inputType = '';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: empty data and explicit path inputType
figNum = 10003;
titleString = sprintf('DEMO case: empty data and explicit path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [];
inputType = 'path';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and path inputType
figNum = 10003;
titleString = sprintf('DEMO case: non-empty data and path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; nan nan; 2 2; 0 4];
inputType = 'path';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and points inputType
figNum = 10004;
titleString = sprintf('DEMO case: non-empty data and points inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; nan nan; 2 2; 0 4];
inputType = 'points';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and patch inputType
figNum = 10005;
titleString = sprintf('DEMO case: non-empty data and patch inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];
inputType = 'patch';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and patch inputType with fewer than 3 points - produces a line
figNum = 10006;
titleString = sprintf('DEMO case: non-empty data and patch inputType with fewer than 3 points - produces a line');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [
    0 0
    1 1
    ];

inputType = 'patch';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and aabb inputType
figNum = 10007;
titleString = sprintf('DEMO case: non-empty data and aabb inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 0; 1 1; 0 1; 0 0];
inputType = 'aabb';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and directedpath inputType
figNum = 10008;
titleString = sprintf('DEMO case: non-empty data and directedpath inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];

inputType = 'directedpath';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: non-empty data and onesidedsegment inputType
figNum = 10009;
titleString = sprintf('DEMO case: non-empty data and onesidedsegment inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];

inputType = 'onesidedsegment';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));



%% Geoplot cases start here.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____ ______ ____  _____  _      ____ _______    _____           _____ ______  _____
%  / ____|  ____/ __ \|  __ \| |    / __ \__   __|  / ____|   /\    / ____|  ____|/ ____|
% | |  __| |__ | |  | | |__) | |   | |  | | | |    | |       /  \  | (___ | |__  | (___
% | | |_ |  __|| |  | |  ___/| |   | |  | | | |    | |      / /\ \  \___ \|  __|  \___ \
% | |__| | |___| |__| | |    | |___| |__| | | |    | |____ / ____ \ ____) | |____ ____) |
%  \_____|______\____/|_|    |______\____/  |_|     \_____/_/    \_\_____/|______|_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=GEOPLOT+CASES&x=none&v=4&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DEMO case: testing with geoplot
figNum = 10004;
titleString = sprintf('DEMO case: testing with geoplot');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [];
hPoints = fcn_GetUserInputPath_getUserInputPath((pathXY),(figNum));

% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: testing with geoplot with previous data
figNum = 10005;
titleString = sprintf('DEMO case: testing with geoplot with previous data');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

LLAdata = [
    40.380301927069773 -79.884128796856004
    40.378814453783740 -79.886003667041678
    40.378669382578792 -79.886219585568057
    40.378433386792231 -79.886604483810743
    40.378353699381059 -79.886780169071329
    40.378136091096778 -79.887313930397440
    40.377928699370855 -79.887838973249472
    40.377836751959194 -79.888072325433768
    40.377773410098470 -79.888193024839410
    40.377716198258547 -79.888294948781976
    40.377520043009973 -79.888603402818688
    40.377489393700806 -79.888643635953898
    40.377448524718410 -79.888706667865804
    40.376353312922461 -79.887279732669882
    40.376189846948471 -79.886737926448873
    40.377142030673902 -79.885364635433248
    40.376524951424727 -79.884527767603231
    40.377505743164747 -79.883186643311959
    40.378204549077431 -79.883926938612660
    40.379258892424218 -79.883980584788716
    40.380010826978442 -79.883723056518534
    40.380301927069773 -79.884128796856004];

plotFormat.Marker = 'none';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Color = [1 0 0];


fcn_plotRoad_plotLL([],[],figNum);
set(gca,'MapCenter',[40.378155494697360 -79.884093253372299],'ZoomLevel',17);

pathXY = LLAdata;
hPoints = fcn_GetUserInputPath_getUserInputPath((pathXY),(figNum));

% sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined
%
% % Make sure plot opened up
% assert(isequal(get(gcf,'Number'),figNum));


%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test figures start with 2

% Commented out since automatic testing will not work with manual inputs
if 1==0

    %% TEST case: invalid inputType throws error
    figNum = 20002;
    titleString = sprintf('TEST case: invalid inputType throws error');
    fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
    figure(figNum); clf;

    pathXY = [];

    try
    	fcn_GetUserInputPath_getUserInputPath((pathXY),(figNum),'invalid_input_type');
    	error('Test failed: invalid inputType did not throw an error.');
    catch ME
    	assert(contains(ME.message,'inputType must be one of'));
    end
    close(figNum);
    close all;
    fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

    %% TEST case: testing with geoplot in patch mode
    figNum = 20004;
    titleString = sprintf('TEST case: geoplot in patch mode');
    fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
    figure(figNum); clf;

    fcn_plotRoad_plotLL([],[],(figNum));
    set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

    pathXY = [];
    hPoints = fcn_GetUserInputPath_getUserInputPath((pathXY),(figNum),'patch');

    % sgtitle(titleString, 'Interpreter','none');

    % Check variable types
    assert(ishandle(hPoints));

    % Check variable sizes
    assert(size(hPoints,1)==1);
    assert(size(hPoints,2)==1);

    % Check variable values
    % User defined

    % % Make sure plot opened up
    % assert(isequal(get(gcf,'Number'),figNum));

    %% TEST case: testing with geoplot in patch mode
    figNum = 20005;
    titleString = sprintf('TEST case: geoplot in patch mode');
    fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
    figure(figNum); clf;

    fcn_plotRoad_plotLL([],[],(figNum));
    set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

    pathXY = [];
    hPoints = fcn_GetUserInputPath_getUserInputPath((pathXY),(figNum),'aabb');

    % sgtitle(titleString, 'Interpreter','none');

    % Check variable types
    assert(ishandle(hPoints));

    % Check variable sizes
    assert(size(hPoints,1)==1);
    assert(size(hPoints,2)==1);

    % Check variable values
    % User defined

    % % Make sure plot opened up
    % assert(isequal(get(gcf,'Number'),figNum));
end

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases - none because this is a plotting function\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     ([]));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     (-1));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
%
% Niterations = 50;
%
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         ([]));
% end
% slow_method = toc;
%
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         (-1));
% end
% fast_method = toc;
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
%
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
%
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG

%% Fail conditions
if 1==0
	%

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
