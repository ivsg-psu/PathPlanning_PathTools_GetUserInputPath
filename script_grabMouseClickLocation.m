% script_test_mouse_grabbing

% Create a figure
current_fig = figure(2);
clf;
num_points = 1000;
data = nan*ones(num_points,2);
next_point = 1;
h_plot = plot(data(:,1),data(:,2),'r.-','Markersize',20,'Linewidth',2);
xlim([-10 10]);
ylim([-10 10]);

% Fill in a UserData structure
UserData.num_points = num_points;
UserData.data = data;
UserData.next_point = next_point;
UserData.h_plot = h_plot;

set(current_fig, 'WindowButtonMotionFcn', @fcn_mouseMove, 'WindowButtonDownFcn',@fcn_mouseClicked);
set(current_fig,'UserData',UserData);

