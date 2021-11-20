function varargout = frontend(varargin)
%EKF-SLAM environment-making GUI
%
% This program permits the graphical creation and manipulation 
% of an environment of point landmarks, and the specification of
% vehicle path waypoints therein.
%
% USAGE: type 'frontend' to start.
%   1. Click on the desired operation: <enter>, <move>, or <delete>.
%   2. Click on the type: <waypoint> or <landmark> to commence the 
%   operation.
%   3. If entering new landmarks or waypoints, click with the left
%   mouse button to add new points. Click the right mouse button, or
%   hit <enter> key to finish.
%   4. To move or delete a point, just click near the desired point.
%   5. Saving maps and loading previous maps is accomplished via the
%   <save> and <load> buttons, respectively.
%
% Tim Bailey and Juan Nieto 2004.

% FRONTEND Application M-file for frontend.fig
%    FIG = FRONTEND launch frontend GUI.
%    FRONTEND('callback_name', ...) invoke the named callback.
global WAYPOINTS LANDMARKS FH

if nargin == 0  % LAUNCH GUI

    %initialisation
%     WAYPOINTS= [0;0]; 
    WAYPOINTS= [];
    LANDMARKS= [];
    
    % open figure
	fig = openfig(mfilename,'reuse');
    hh= get(fig, 'children');
    set(hh(3), 'value', 1)
    
    hold on
    FH.hl= plot(0,0,'g*'); plot(0,0,'w*')
    FH.hw= plot(0,0,'ro'); plot(0,0,'wo')
%     FH.hw= plot(0,0,0,0,'ro');
%     plotwaypoints(WAYPOINTS);

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    set(fig,'name', 'GUI')

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


% --------------------------------------------------------------------
function varargout = waypoint_checkbox_Callback(h, eventdata, handles, varargin)
global WAYPOINTS
set(handles.landmark_checkbox, 'value', 0)
WAYPOINTS= perform_task(WAYPOINTS, handles.waypoint_checkbox, handles);
plotwaypoints(WAYPOINTS);

% --------------------------------------------------------------------
function varargout = landmark_checkbox_Callback(h, eventdata, handles, varargin)
global LANDMARKS
set(handles.waypoint_checkbox, 'value', 0)
LANDMARKS= perform_task(LANDMARKS, handles.landmark_checkbox, handles);
plotlandmarks(LANDMARKS);

% --------------------------------------------------------------------
function varargout = enter_checkbox_Callback(h, eventdata, handles, varargin)
set(handles.enter_checkbox, 'value', 1)
set(handles.move_checkbox, 'value', 0)
set(handles.delete_checkbox, 'value', 0)

% --------------------------------------------------------------------
function varargout = move_checkbox_Callback(h, eventdata, handles, varargin)
set(handles.enter_checkbox, 'value', 0)
set(handles.move_checkbox, 'value', 1)
set(handles.delete_checkbox, 'value', 0)

% --------------------------------------------------------------------
function varargout = delete_checkbox_Callback(h, eventdata, handles, varargin)
set(handles.enter_checkbox, 'value', 0)
set(handles.move_checkbox, 'value', 0)
set(handles.delete_checkbox, 'value', 1)

% --------------------------------------------------------------------
function varargout = load_button_Callback(h, eventdata, handles, varargin)
global WAYPOINTS LANDMARKS
seed = {'*.mat','MAT-files (*.mat)'};
[fn,pn] = uigetfile(seed, 'Load landmarks and waypoints');
if fn==0, return, end

fnpn = strrep(fullfile(pn,fn), '''', '''''');
load(fnpn)
WAYPOINTS= class1; LANDMARKS= class2;
plotwaypoints(WAYPOINTS);
plotlandmarks(LANDMARKS);

% --------------------------------------------------------------------
function varargout = save_button_Callback(h, eventdata, handles, varargin)
global WAYPOINTS LANDMARKS
class1= WAYPOINTS; class2= LANDMARKS;
seed = {'*.mat','MAT-files (*.mat)'};
[fn,pn] = uiputfile(seed, 'Save landmarks and waypoints');
if fn==0, return, end

fnpn = strrep(fullfile(pn,fn), '''', '''''');
save(fnpn, 'class1', 'class2');

% --------------------------------------------------------------------
function plotwaypoints(x)
global FH
set(FH.hw, 'xdata', x(1,:), 'ydata', x(2,:))

% --------------------------------------------------------------------
function plotlandmarks(x)
global FH
set(FH.hl, 'xdata', x(1,:), 'ydata', x(2,:))

% --------------------------------------------------------------------
function i= find_nearest(x)
xp= ginput(1);
d2= (x(1,:)-xp(1)).^2 + (x(2,:)-xp(2)).^2;
i= find(d2 == min(d2));
i= i(1);

% --------------------------------------------------------------------
function x= perform_task(x, h, handles)
        
if get(h, 'value') == 1
    zoom off
    
    if get(handles.enter_checkbox, 'value') == 1 % enter points
        [xn,yn,bn]= ginput(1);
        while ~isempty(xn) & bn == 1
            x= [x [xn;yn]];
            if h == handles.waypoint_checkbox
                plotwaypoints(x); 
            else
                plotlandmarks(x);
            end
            [xn,yn,bn]= ginput(1);
        end                
    else
        i= find_nearest(x);        
        if get(handles.delete_checkbox, 'value') == 1 % delete nearest point
            x= [x(:,1:i-1) x(:,i+1:end)];
            
        elseif get(handles.move_checkbox, 'value') == 1 % move nearest point
            xt= x(:,i);
            plot(xt(1), xt(2),'kx', 'markersize',10)
            x(:,i)= ginput(1)';
            plot(xt(1), xt(2),'wx', 'markersize',10)
        end            
    end
    
    set(h, 'value', 0)
end
function varargout = slove_button_Callback(h, eventdata, handles, varargin)
clc
load('dl.mat');
w =[ 1 1 1 0;
     0 0 0 1];
syms x y;
wp = class1;   
lm = class2;
% t?o ma tr?n r?ng U 
U = zeros(4,length(wp)+length(lm));
% ??a d? li?u v�o ma tr?n U
for i=1:length(wp)
 U(1,i)=wp(1,i);
 U(2,i)=wp(2,i);
 U(3,i) = 1;
 U(4,i) = 1;
end
for i= length(wp)+1:length(U)
    U(1,i)=lm(1,i-length(wp));
    U(2,i)=lm(2,i-length(wp));
    U(3,i)=1;
    U(4,i)= 0;
end
% T?o mot ma tr?n w b?t k� dang w=[ wx wy w0 0
                             %  0 0 0 1]

 a = w*U;
% giai b�i to�n
dem = 0;
while xet(U,w) == 0 
    a = w*U;
   i = randi(length(U),1,1);
 if U(4,i) == 1
  if sign(a(1,i))< 0
       w(1,1) =(w(1,1) +U(1,i))/10;
       w(1,2) = (w(1,2) + U(2,i))/10;
       w(1,3) = (w(1,3) + U(3,i))/10;  
       dem = dem +1;
  end
 end
   if sign(a(1,i))>= 0
       w(1,1) =(w(1,1) - U(1,i))/10;
       w(1,2) = (w(1,2) - U(2,i))/10;
       w(1,3) = (w(1,3) - U(3,i))/10; 
       dem = dem +1;
   end
   
    x =-100:1:100;
    y = (-w(1,1)*x-w(1,3))/w(1,2); 
    plot(x,y,'r');
     hold on
   plot_dl(U);
   xlabel(dem);
   grid on;
   hold off
   pause(0.4)
end  
 
