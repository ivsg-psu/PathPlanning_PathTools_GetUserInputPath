function fcn_mouseClicked(hObject,~)
%mousePos=get(hObject,'CurrentPoint');
mousePos = get (gca, 'CurrentPoint');
disp(['You clicked X:',num2str(mousePos(1)),',  Y:',num2str(mousePos(2))]);

UserData = get(gcf,'UserData');
num_points = UserData.num_points;
data = UserData.data;

% Fill in the current point
current_point = UserData.next_point;
data(current_point,1) = mousePos(1,1);
data(current_point,2) = mousePos(1,2);

% Find the point after the current point, and shift data down if "full"
next_point = current_point+1;
if next_point == (num_points+1)
    data(1:end-1,:) = data(2:end,:);
    next_point = num_points;
end

% Update the plot
set(UserData.h_plot,'XData',data(:,1),'YData',data(:,2));

%UserData.num_points = num_points;
UserData.data = data;
UserData.next_point = next_point;

% Save the results
set(gcf,'UserData',UserData);
end