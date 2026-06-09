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
% 
% 2026_06_08 by Sean Brennan, sbrennan@psu.edu 
% - In script_test_fcn_GetUserInputPath_updateDrawing
%   % * Fixed bug found in non-empty data and patch input, case 20005
%   % * Changed hLine output type to enable multiple handles and arrays of
%   %   % handles, to cell type. Allows patch, quivers, etc.
%   % * Added all test cases for regular and geoplotting

% TO-DO:
%
% 2026_06_08 by Jaime Rodriguez
% - In script_test_fcn_GetUserInputPath_updateDrawing

%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _   _  ____  _____  __  __          _        _____  _      ____ _______
% | \ | |/ __ \|  __ \|  \/  |   /\   | |      |  __ \| |    / __ \__   __|
% |  \| | |  | | |__) | \  / |  /  \  | |      | |__) | |   | |  | | | |
% | . ` | |  | |  _  /| |\/| | / /\ \ | |      |  ___/| |   | |  | | | |
% | |\  | |__| | | \ \| |  | |/ ____ \| |____  | |    | |___| |__| | | |
% |_| \_|\____/|_|  \_\_|  |_/_/    \_\______| |_|    |______\____/  |_|
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=NORMAL+PLOT&x=none&v=4&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXX: NORMAL PLOT cases - all are interactive so commented out\n');

%% NORMAL PLOT case: empty data and empty inputType example
figNum = 10001;
titleString = sprintf('NORMAL PLOT case: empty data and empty inputType example');
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

%% NORMAL PLOT case: non-empty data and empty inputType - defaults to path
figNum = 10002;
titleString = sprintf('NORMAL PLOT case: non-empty data and empty inputType - defaults to path');
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

%% NORMAL PLOT case: empty data and explicit path inputType
figNum = 10003;
titleString = sprintf('NORMAL PLOT case: empty data and explicit path inputType');
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

%% NORMAL PLOT case: non-empty data and path inputType
figNum = 10003;
titleString = sprintf('NORMAL PLOT case: non-empty data and path inputType');
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

%% NORMAL PLOT case: non-empty data and points inputType
figNum = 10004;
titleString = sprintf('NORMAL PLOT case: non-empty data and points inputType');
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

%% NORMAL PLOT case: non-empty data and patch inputType
figNum = 10005;
titleString = sprintf('NORMAL PLOT case: non-empty data and patch inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];
inputType = 'patch';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line
figNum = 10006;
titleString = sprintf('NORMAL PLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line');
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
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PLOT case: non-empty data and aabb inputType
figNum = 10007;
titleString = sprintf('NORMAL PLOT case: non-empty data and aabb inputType');
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

%% NORMAL PLOT case: non-empty data and directedpath inputType
figNum = 10008;
titleString = sprintf('NORMAL PLOT case: non-empty data and directedpath inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];

inputType = 'directedpath';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PLOT case: non-empty data and onesidedsegment inputType
figNum = 10009;
titleString = sprintf('NORMAL PLOT case: non-empty data and onesidedsegment inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];

inputType = 'onesidedsegment';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

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

% Geoplot figures start with 2
close all;
fprintf(1,'Figure: 2XXXX: GEOPLOT mode cases\n');

%% GEOPLOT case: empty data and empty inputType example
figNum = 20001;
titleString = sprintf('GEOPLOT case: empty data and empty inputType example');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

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

%% GEOPLOT case: non-empty data and empty inputType - defaults to path
figNum = 20002;
titleString = sprintf('GEOPLOT case: non-empty data and empty inputType - defaults to path');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
];

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

%% GEOPLOT case: empty data and explicit path inputType
figNum = 20003;
titleString = sprintf('GEOPLOT case: empty data and explicit path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
];

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

%% GEOPLOT case: non-empty data and path inputType
figNum = 20003;
titleString = sprintf('GEOPLOT case: non-empty data and path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

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

%% GEOPLOT case: non-empty data and points inputType
figNum = 20004;
titleString = sprintf('GEOPLOT case: non-empty data and points inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

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

%% GEOPLOT case: non-empty data and patch inputType
figNum = 20005;
titleString = sprintf('GEOPLOT case: non-empty data and patch inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);


pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

inputType = 'patch';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line
figNum = 20006;
titleString = sprintf('GEOPLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);


pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643  
];

inputType = 'patch';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT case: non-empty data and aabb inputType
figNum = 20007;
titleString = sprintf('GEOPLOT case: non-empty data and aabb inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    40.79365 -77.8642 
];

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

%% GEOPLOT case: non-empty data and directedpath inputType
figNum = 20008;
titleString = sprintf('GEOPLOT case: non-empty data and directedpath inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

inputType = 'directedpath';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT case: non-empty data and onesidedsegment inputType
figNum = 20009;
titleString = sprintf('GEOPLOT case: non-empty data and onesidedsegment inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);


pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

inputType = 'onesidedsegment';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  _   _                            _
% | \ | |                          | |
% |  \| | ___  _ __ _ __ ___   __ _| |
% | . ` |/ _ \| '__| '_ ` _ \ / _` | |
% | |\  | (_) | |  | | | | | | (_| | |
% |_|_\_|\___/|_| _|_|_|_| |_|\__,_|_|  _
% |  __ \        |  ____|    (_)   | | (_)
% | |__) | __ ___| |__  __  ___ ___| |_ _ _ __   __ _
% |  ___/ '__/ _ \  __| \ \/ / / __| __| | '_ \ / _` |
% | |   | | |  __/ |____ >  <| \__ \ |_| | | | | (_| |
% |_|___|_|  \___|______/_/\_\_|___/\__|_|_| |_|\__, |
% |  __ \| |     | |    / ____|                  __/ |
% | |__) | | ___ | |_  | |     __ _ ___  ___  __|___/
% |  ___/| |/ _ \| __| | |    / _` / __|/ _ \/ __|
% | |    | | (_) | |_  | |___| (_| \__ \  __/\__ \
% |_|    |_|\___/ \__|  \_____\__,_|___/\___||___/
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Normal%0APreExisting%0APlot+Cases&x=none&v=4&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 3

close all;
fprintf(1,'Figure: 3XXXX: NORMAL PREEXISTING PLOT cases - all are interactive so commented out\n');

%% NORMAL PREEXISTING PLOT case: empty data and empty inputType example
figNum = 30001;
titleString = sprintf('NORMAL PREEXISTING PLOT case: empty data and empty inputType example');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [1 2; 3 4];
inputType = '';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [];
inputType = '';
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

%% NORMAL PREEXISTING PLOT case: non-empty data and empty inputType - defaults to path
figNum = 30002;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and empty inputType - defaults to path');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

pathXY = [1 2; 3 4];
inputType = '';
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [2 2; 7 1];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));


% Check variable types
assert(ishandle(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==1);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PREEXISTING PLOT case: empty data and explicit path inputType
figNum = 30003;
titleString = sprintf('NORMAL PREEXISTING PLOT case: empty data and explicit path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'path';
pathXY = [2 2; 7 1];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [];
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

%% NORMAL PREEXISTING PLOT case: non-empty data and path inputType
figNum = 30003;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'path';
pathXY = [2 2; 7 1];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [0 0; 1 1; nan nan; 2 2; 0 4];
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

%% NORMAL PREEXISTING PLOT case: non-empty data and points inputType
figNum = 30004;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and points inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'points';
pathXY = [2 2; 7 1];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [0 0; 1 1; nan nan; 2 2; 0 4];
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

%% NORMAL PREEXISTING PLOT case: non-empty data and patch inputType
figNum = 30005;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and patch inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'patch';
pathXY = [2 2; 7 1; 5 6];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PREEXISTING PLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line
figNum = 30006;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and patch inputType with fewer than 3 points - produces a line');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


inputType = 'patch';
pathXY = [2 2; 7 1; 5 6];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (-1));
pause(1);
pathXY = [
    0 0
    1 1
    ];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PREEXISTING PLOT case: non-empty data and aabb inputType
figNum = 30007;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and aabb inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'aabb';
pathXY = [2 2; 7 1; 5 6];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);
pathXY = [0 0; 1 0; 1 1; 0 1; 0 0];
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

%% NORMAL PREEXISTING PLOT case: non-empty data and directedpath inputType
figNum = 30008;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and directedpath inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'directedpath';
pathXY = [2 2; 7 1; 5 6];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);
pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% NORMAL PREEXISTING PLOT case: non-empty data and onesidedsegment inputType
figNum = 30009;
titleString = sprintf('NORMAL PREEXISTING PLOT case: non-empty data and onesidedsegment inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

inputType = 'onesidedsegment';
pathXY = [2 2; 7 1; 5 6];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);
pathXY = [0 0; 1 1; 0 1; nan nan; 2 2; 0 4; -1 3];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));



%% Geoplot cases start here.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                  _       _
%  / ____|                | |     | |
% | |  __  ___  ___  _ __ | | ___ | |_
% | | |_ |/ _ \/ _ \| '_ \| |/ _ \| __|
% | |__| |  __/ (_) | |_) | | (_) | |_
%  \_____|\___|\___/| .__/|_|\___/ \__|
%                   | |
%  _____          __|_|_      _     _   _
% |  __ \        |  ____|    (_)   | | (_)
% | |__) | __ ___| |__  __  ___ ___| |_ _ _ __   __ _
% |  ___/ '__/ _ \  __| \ \/ / / __| __| | '_ \ / _` |
% | |   | | |  __/ |____ >  <| \__ \ |_| | | | | (_| |
% |_|___|_|  \___|______/_/\_\_|___/\__|_|_| |_|\__, |
%  / ____|                                       __/ |
% | |     __ _ ___  ___  ___                    |___/
% | |    / _` / __|/ _ \/ __|
% | |___| (_| \__ \  __/\__ \
%  \_____\__,_|___/\___||___/
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Geoplot%0APreExisting%0ACases&x=none&v=4&h=4&w=80&we=false
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geoplot figures start with 4
close all;
fprintf(1,'Figure: 4XXXX: GEOPLOT PREEXISTING mode cases\n');

%% GEOPLOT PREEXISTING case: empty data and empty inputType example
figNum = 40001;
titleString = sprintf('GEOPLOT PREEXISTING case: empty data and empty inputType example');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = '';
pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

pause(1);
pathXY = [];
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

%% GEOPLOT PREEXISTING case: non-empty data and empty inputType - defaults to path
figNum = 40002;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and empty inputType - defaults to path');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = '';
pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);
pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
];
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

%% GEOPLOT PREEXISTING case: empty data and explicit path inputType
figNum = 40003;
titleString = sprintf('GEOPLOT PREEXISTING case: empty data and explicit path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);


inputType = 'path';
pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
];
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

%% GEOPLOT PREEXISTING case: non-empty data and path inputType
figNum = 40003;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and path inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'path';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);


pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];
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

%% GEOPLOT PREEXISTING case: non-empty data and points inputType
figNum = 40004;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and points inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'points';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

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

%% GEOPLOT PREEXISTING case: non-empty data and patch inputType
figNum = 40005;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and patch inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'patch';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT PREEXISTING case: non-empty data and patch inputType with fewer than 3 points - produces a line
figNum = 40006;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and patch inputType with fewer than 3 points - produces a line');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'patch';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643  
];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT PREEXISTING case: non-empty data and aabb inputType
figNum = 40007;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and aabb inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);


inputType = 'aabb';
pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    40.79365 -77.8642 
];

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

%% GEOPLOT PREEXISTING case: non-empty data and directedpath inputType
figNum = 40008;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and directedpath inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'directedpath';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);


pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% GEOPLOT PREEXISTING case: non-empty data and onesidedsegment inputType
figNum = 40009;
titleString = sprintf('GEOPLOT PREEXISTING case: non-empty data and onesidedsegment inputType');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

fcn_plotRoad_plotLL([],[],(figNum));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);

inputType = 'onesidedsegment';

pathXY = [
    40.79382 -77.8646
    40.79385 -77.8643
    40.79381 -77.864
];
hPoints = [];
hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));
pause(1);

pathXY = [
    40.79385 -77.8646
    40.79375 -77.8643
    40.79355 -77.864
    nan nan
    40.79365 -77.8642
    40.79345 -77.8645
    40.79375 -77.8642    
];

hPoints = fcn_GetUserInputPath_updateDrawing(pathXY, (inputType), (hPoints), (figNum));

% Check variable types
assert(iscell(hPoints));

% Check variable sizes
assert(size(hPoints,1)==1);
assert(size(hPoints,2)==2);

% Check variable values
% User defined

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));



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
% Test figures start with 5
close all;
fprintf(1,'Figure: 5XXXX: TEST mode cases - none because this is a plotting function\n');

% Commented out since automatic testing will not work with manual inputs
if 1==0

    %% TEST case: invalid inputType throws error
    figNum = 50001;
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
    figNum = 50004;
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
    figNum = 50005;
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
