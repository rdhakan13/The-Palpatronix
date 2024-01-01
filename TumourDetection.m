function varargout = TumourDetection(varargin)
% TumourDetection.m (Code completed in R2018b) by Muhab Hasan (mn18mh), Raj Dhakan (mn18rad), Shion Lahiri (mn18sl)
%
% TumourDetection is a GUI which enables the user to detect existing tumours and potentially growing tumours in a tissue sample
%
% Last Modified by GUIDE v2.5 22-Apr-2019 19:31:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TumourDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @TumourDetection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TumourDetection is made visible.
function TumourDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TumourDetection (see VARARGIN)

clc; % clears command window 

% Choose default command line output for TumourDetection
handles.output = hObject;

% Disables the middle 3 buttons until the file is loaded
set(handles.analyse_data,'Enable','off');
set(handles.save,'Enable','off');
set(handles.reset,'Enable','off');

% Hides the text saying there are no potential tumours
set(handles.cover, 'Visible', 'off');
set(handles.cover2, 'Visible', 'off');

% clears the static text box which presents the no. of tumours/potential
% tumours
set(handles.no_of_tumours_text, 'String', " ");
set(handles.no_of_potential_tumours, 'String', " ");

% disables the option to change the graph
set(handles.pcolour,'Enable','off');
set(handles.contour,'Enable','off');
set(handles.surface,'Enable','off');

% logo image displayed
Image = imread("assignment_logo.jpg");
axes(handles.graph);
imshow(Image);
hold off;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TumourDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TumourDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pcolour.
function pcolour_Callback(hObject, eventdata, handles)
% hObject    handle to pcolour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('graph_button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

% calls back to the analyse_data function to change the graph to pcolor
analyse_data_Callback(handles.analyse_data, [], handles);

% --- Executes on button press in surface.
function surface_Callback(hObject, eventdata, handles)
% hObject    handle to surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('graph_button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

% calls back to the analyse_data function to change the graph to surface
analyse_data_Callback(handles.analyse_data, [], handles);

% --- Executes on button press in contour.
function contour_Callback(hObject, eventdata, handles)
% hObject    handle to contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('graph_button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

% calls back to the analyse_data function to change the graph to contour
analyse_data_Callback(handles.analyse_data, [], handles);

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

%% reading file

% makes the following variables global
global force_data depth x_resolution y_resolution file_name

file_name = uigetfile('*.csv','Please select a CSV file'); % opens 
% a window from which user selects a file

if file_name==0 % if no files are selected the program returns
    return
end 

% readingfile is a user-defined function which reads the file and checks
% whether it is of the correct type and in correct format
[x_resolution,y_resolution,depth,...
    force_data] = readingfile(file_name);

proceed = error_check(force_data); % error_check is user-defined function 
% which checks if the data is corrupted or not 
if (proceed == "No")||(proceed == "")||(isempty(force_data)==1)
    return % if they select to not proceed then the program stops
end 

% displays an image to the user to inform them how the coordinate-system
% is set up based on the palpatronix system
Image = imread("coordinates.png");
axes(handles.graph);
imshow(Image);
hold off;

% only of user agrees to proceed will the analyse button be active
if isempty(force_data)==0 && (proceed=="Yes")
    set(handles.analyse_data,'Enable','on');
end

% changes button name to reload so that user can choose to change the file
% loaded
set(handles.load,'String','RE-LOAD');

% --- Executes on button press in analyse_data.
function analyse_data_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% enables the feature to change the graphs
set(handles.pcolour,'Enable','on');
set(handles.contour,'Enable','on');
set(handles.surface,'Enable','on');

% button sound
[y, Fs] = audioread('button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

global force_data depth x_resolution y_resolution force_dim stiffness_data...
    x_array y_array tumour_data potential_tumour_data binary_array...
    size_of_tumour

% removes the picture from the axis
cla(handles.graph,'reset');

%% determining the graph type selected from the radio buttons

handles.a = get(handles.graph_selection,'SelectedObject');
graph_type = get(handles.a,'Tag');
handles.graph_type = convertCharsToStrings(graph_type);
guidata(hObject, handles);

%% going through the entire force_data to convert to stiffness values

force_dim = size(force_data); % calculates the dimensions 
% of the matrix which holds the force data
stiffness_data = (force_data)/(depth); % stiffness is
% calculated from force by dividing it by the depth

% creating the x and y coordinates which is used later to find the location
% of the tumour(s) 
x_array = x_resolution*(0:force_dim(2)-1); % x coordinate system
y_array = y_resolution*(0:force_dim(1)-1); % y coordinate system

%% filtering data and calculations
% filtration is a user-defined function which filtered the data to find the
% location of tumours and possible/potential growth of tumours
[tumour_data,potential_tumour_data,binary_array,size_of_tumour] = ...
    filtration(stiffness_data,force_dim,x_array,y_array,x_resolution,y_resolution);

%% plotting the graph

if handles.graph_type == 'pcolour'
    pcolor(handles.graph,x_array, y_array, stiffness_data);
    xlabel('x coordinates (mm)');
    ylabel('y coordinates (mm)');
    title('Stiffness vs Coordinates');
    c = colorbar; 
    colormap hot;
    brighten(0.5);
    shading interp;
    ylabel(c, 'Stiffness (N/m)')
    rotate3d off;
elseif handles.graph_type == 'contour'
    contour(handles.graph, x_array, y_array,stiffness_data);
    xlabel('x coordinates (mm)');
    ylabel('y coordinates (mm)');
    title('Stiffness vs Coordinates');
    c = colorbar; 
    ylabel(c, 'Stiffness (N/m)');
    rotate3d off;
else
    surf(handles.graph, x_array, y_array,stiffness_data);
    xlabel('x coordinates (mm)');
    ylabel('y coordinates (mm)');
    zlabel('Stiffness (N/m)');
    title('Stiffness vs Coordinates');
    colormap hot; % colour scheme of the surface plot
    brighten(0.5);
    rotate3d on ; % enables the user to rotate the surface plot
    hold on;
    if isempty(tumour_data)==0
        plot3(tumour_data(:,2),tumour_data(:,3),tumour_data(:,4),'bO'); % marks the 
        % position of the tumours on the surface plot by drawing a red circle
    end 
    if isempty(potential_tumour_data) ~= 1
        plot3(potential_tumour_data(:,2),potential_tumour_data(:,3)...
        ,potential_tumour_data(:,4),'gO'); % marks the position of potential 
        % tumours on the surface plot by drawing a yellow circle
    end
    hold off;
end

%% displaying the number of tumours and potential tumours
if isempty(tumour_data)==0
    no_of_tumours = size(tumour_data,1);
    text_label1 = sprintf('No of tumours = %d', no_of_tumours);
    set(handles.no_of_tumours_text, 'String', text_label1);
    potential_no_of_tumours = size(potential_tumour_data,1);
    text_label2 = sprintf('No of potential tumours = %d', potential_no_of_tumours);
    set(handles.no_of_potential_tumours, 'String', text_label2);
    guidata(hObject, handles);

    %% displaying data on table

    set(handles.tumour_data_table, 'Data', round(tumour_data(:,2:end),2,'decimals'));
    set(handles.potential_tumour_table, 'Data', round(potential_tumour_data(:,2:end),2,'decimals'));
    if isempty(potential_tumour_data) == 1
        set(handles.cover, 'Visible', 'On');
    else 
        set(handles.cover, 'Visible', 'Off');
    end

    %% enabling the other two buttons and disables load button and analyse button

    set(handles.save,'Enable','on');
    set(handles.reset,'Enable','on');
    set(handles.load,'Enable','off');

    % changes button name to back load
    set(handles.load,'String','LOAD');

    set(handles.analyse_data,'Enable','off');
else 
    set(handles.save,'Enable','on');
    set(handles.cover2, 'Visible', 'on');
    set(handles.analyse_data,'Enable','off');
    set(handles.reset,'Enable','on');
    % changes button name to back load
    set(handles.load,'String','LOAD');
end 
% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

%% saving file

global file_name tumour_data potential_tumour_data y_array x_array binary_array
% prompts the user to select the method to save the file
save_file_prompt(tumour_data,potential_tumour_data,file_name,y_array,...
    x_array,binary_array,handles.graph);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

%% resetting the GUI

set(handles.analyse_data,'Enable','off');
set(handles.save,'Enable','off');
set(handles.reset,'Enable','off');
cla(handles.graph,'reset');
set(handles.tumour_data_table, 'Data', []);
set(handles.potential_tumour_table, 'Data', []);
set(handles.cover, 'Visible', 'Off');
set(handles.cover2, 'Visible', 'off');
set(handles.no_of_tumours_text, 'String', " ");
set(handles.no_of_potential_tumours, 'String', " ");
set(handles.pcolour,'Enable','off');
set(handles.contour,'Enable','off');
set(handles.surface,'Enable','off');
set(handles.load,'Enable','on');
Image = imread("assignment_logo.jpg");
axes(handles.graph);
imshow(Image);
hold off;

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% button sound
[y, Fs] = audioread('button.mp3');
player = audioplayer(y, Fs);
playblocking(player);

%% exits

delete(handles.figure1);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pcolour.
function pcolour_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pcolour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function graph_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph


% --- Executes when entered data in editable cell(s) in tumour_data_table.
function tumour_data_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tumour_data_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
