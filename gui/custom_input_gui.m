% GUI Script for Custom Input of an AIF into the PK Simulation
% This GUI allows users to specify a text file or equation to be used as an
% AIF.
% 
% Author: Tom Morin
% Date: June 2015
%
function varargout = custom_input_gui(varargin)
%CUSTOM_INPUT_GUI M-file for custom_input_gui.fig
%      CUSTOM_INPUT_GUI, by itself, creates a new CUSTOM_INPUT_GUI or raises the existing
%      singleton*.
%
%      H = CUSTOM_INPUT_GUI returns the handle to a new CUSTOM_INPUT_GUI or the handle to
%      the existing singleton*.
%
%      CUSTOM_INPUT_GUI('Property','Value',...) creates a new CUSTOM_INPUT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to custom_input_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CUSTOM_INPUT_GUI('CALLBACK') and CUSTOM_INPUT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CUSTOM_INPUT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help custom_input_gui

% Last Modified by GUIDE v2.5 25-Jun-2015 15:28:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @custom_input_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @custom_input_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before custom_input_gui is made visible.
function custom_input_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

global Custom_Options custom_input original_input;

custom_input = [];
original_input = [];

% Choose default command line output for custom_input_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set up the look of the graph & gui window before making it visible
set(handles.options,'String',{'Load .txt File','Use Custom Equation'});
set(handles.options,'Value',1);
set(handles.units,'String',{'Seconds (s)', 'Minutes (m)', 'Hours (h)'});
set(handles.units,'Value',2);
set(handles.equation_panel,'Visible','off');
set(handles.axes,'FontSize',7);
xlabel(handles.axes,'Time (min)','FontSize',8);
ylabel(handles.axes,'Activity (arb. units)','FontSize',8);

% Set the user's previous options
if isfield(Custom_Options, 'filename')
    set(handles.filename,'String',Custom_Options.filename);
    if ~strcmp('Select a file', Custom_Options.filename)
        contents = cellstr(get(handles.units,'String'));
        time_units = contents{get(handles.units,'Value')};
        original_input = dlmread(Custom_Options.filename,'\t',1,0);
        custom_input(:,2) = original_input(:,2);
        if strcmp(time_units,'Seconds (s)')
            custom_input(:,1) = original_input(:,1)./60;
        elseif strcmp(time_units,'Minutes (m)')
            custom_input(:,1) = original_input(:,1);
        elseif strcmp(time_units,'Hours (h)')
            custom_input(:,1) = original_input(:,1).*60;
        end
        plot_now_Callback(hObject,eventdata,handles);
    end
end
if isfield(Custom_Options, 'units')
    set(handles.units,'Value',Custom_Options.units);
end
if isfield(Custom_Options, 'equation')
    set(handles.equation,'String',Custom_Options.equation);
end
if isfield(Custom_Options, 'duration')
    set(handles.scan_time,'String',Custom_Options.duration);
end

% UIWAIT makes custom_input_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = custom_input_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pressed_ok; % Tells previous GUI that user pressed 'continue' instead of exiting
global custom_input;
global original_input; % Is never modified unless a new file is read in
global Custom_Options; % Struct to store user input so it can be redisplayed
global generated_txt_file; % The name of a file generated from an equation
contents = cellstr(get(handles.options,'String'));
option = contents{get(handles.options,'Value')};

% Use a text file if this is specified by user
if strcmp(option,'Load .txt File')
    contents = cellstr(get(handles.units,'String'));
    time_units = contents{get(handles.units,'Value')};
    
    if strcmp(time_units,'Seconds (s)')
        custom_input(:,1) = original_input(:,1)./60;
    elseif strcmp(time_units,'Minutes (m)')
        custom_input(:,1) = original_input(:,1);
    elseif strcmp(time_units,'Hours (h)')
        custom_input(:,1) = original_input(:,1).*60;
    end
end

pressed_ok = true;

% Store the user's selections so they can be re-loaded next time.
if strcmp(option,'Load .txt File')
    Custom_Options.method = 'Load .txt File';
    Custom_Options.filename = get(handles.filename,'String');
    Custom_Options.units = get(handles.units,'Value');
else
    Custom_Options.method = 'Use Custom Equation';
    Custom_Options.filename = generated_txt_file;
    Custom_Options.units = 2;
    Custom_Options.equation = get(handles.equation,'String');
    Custom_Options.duration = get(handles.scan_time,'String');
end

close(gcf);

% --- Executes on button press in generate_txt.
function generate_txt_Callback(hObject, eventdata, handles)
% hObject    handle to generate_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global custom_input generated_txt_file;
custom_func = get(handles.equation,'String');

% Create a matrix with time interval 0.5 minutes and y-values equal to the
% results of the user specified equation
dur = str2num(get(handles.scan_time,'String'));
t = [0:0.5:dur];
data(:,1) = t;
data(:,2) = eval(custom_func);

% Save the data to a text file
[filename, pathname] = uiputfile('*.txt','Location for New Text File', 'custom_data.txt');
generated_txt_file = fullfile(pathname, filename);
print_list({'Time','Data'},data,fullfile(pathname,filename),4);
custom_input = data;

plot_now_Callback(hObject,eventdata,handles);


function scan_time_Callback(hObject, eventdata, handles)
% hObject    handle to scan_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scan_time as text
%        str2double(get(hObject,'String')) returns contents of scan_time as a double


% --- Executes during object creation, after setting all properties.
function scan_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scan_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function equation_Callback(hObject, eventdata, handles)
% hObject    handle to equation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of equation as text
%        str2double(get(hObject,'String')) returns contents of equation as a double


% --- Executes during object creation, after setting all properties.
function equation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in units.
function units_Callback(hObject, eventdata, handles)
% hObject    handle to units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns units contents as cell array
%        contents{get(hObject,'Value')} returns selected item from units

global original_input; % This is only changed when a new file is read in
global custom_input;

% Convert time axis to minutes via conversion factor that depends on user
% selection
contents = cellstr(get(handles.units,'String'));
time_units = contents{get(handles.units,'Value')};
if strcmp(time_units,'Seconds (s)')
    custom_input(:,1) = original_input(:,1)./60;
elseif strcmp(time_units,'Minutes (m)')
    custom_input(:,1) = original_input(:,1);
elseif strcmp(time_units,'Hours (h)')
    custom_input(:,1) = original_input(:,1).*60;
end



% --- Executes during object creation, after setting all properties.
function units_CreateFcn(hObject, eventdata, handles)
% hObject    handle to units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global original_input; % This is only changed when a new file is read in
global custom_input;

% Redefine variables to overwrite any existing data
original_input = [];
custom_input = [];

% Open a text file and read it into the  original_input matrix
[filename, pathname] = uigetfile('*.txt');
set(handles.filename,'String',[pathname,filename]);
original_input = dlmread(fullfile(pathname,filename),'\t',1,0);
custom_input(:,2) = original_input(:,2);

% Depending on the selected time units, convert the time axis to minutes
contents = cellstr(get(handles.units,'String'));
time_units = contents{get(handles.units,'Value')};
if strcmp(time_units,'Seconds (s)')
    custom_input(:,1) = original_input(:,1)./60;
elseif strcmp(time_units,'Minutes (m)')
    custom_input(:,1) = original_input(:,1);
elseif strcmp(time_units,'Hours (h)')
    custom_input(:,1) = original_input(:,1).*60;
end

plot_now_Callback(hObject,eventdata,handles);


% --- Executes on selection change in options.
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from options

% Show either the loading tools or the equation tools depending on user
% selection
contents = cellstr(get(handles.options,'String'));
option = contents{get(handles.options,'Value')};

if strcmp(option,'Load .txt File')
    set(handles.load_panel,'Visible','on');
    set(handles.equation_panel,'Visible','off');
else
    set(handles.load_panel,'Visible','off');
    set(handles.equation_panel,'Visible','on');
end


% --- Executes during object creation, after setting all properties.
function options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
% --- Executes on button press in plot_now.
function plot_now_Callback(hObject, eventdata, handles)
% hObject    handle to plot_now (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plots the current AIF on the axes
global custom_input;
assignin('base','custom_input',custom_input);

plot(handles.axes,custom_input(:,1),custom_input(:,2),'-r','Linewidth',2);
xlabel(handles.axes,'Time (min)','FontSize',8);
ylabel(handles.axes,'Activity (arb. units)','FontSize',8);
set(handles.axes,'FontSize',7);
