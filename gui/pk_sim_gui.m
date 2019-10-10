% GUI Script for PK Simulation
% 
% Author: Tom Morin
% Date: June 2015
%
%%
function varargout = pk_sim_gui(varargin)
% PK_SIM_GUI MATLAB code for pk_sim_gui.fig
%      PK_SIM_GUI, by itself, creates a new PK_SIM_GUI or raises the existing
%      singleton*.
%
%      H = PK_SIM_GUI returns the handle to a new PK_SIM_GUI or the handle to
%      the existing singleton*.
%
%      PK_SIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PK_SIM_GUI.M with the given input arguments.
%
%      PK_SIM_GUI('Property','Value',...) creates a new PK_SIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pk_sim_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pk_sim_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pk_sim_gui

% Last Modified by GUIDE v2.5 02-Feb-2016 11:18:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pk_sim_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @pk_sim_gui_OutputFcn, ...
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


% --- Executes just before pk_sim_gui is made visible.
function pk_sim_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pk_sim_gui (see VARARGIN)

% Choose default command line output for pk_sim_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Initialize the User Options
global Kbol num_kbol BI_Options Custom_Options global_tracers ax k2_prime;
ax(1) = handles.subgraph1;
ax(2) = handles.subgraph2;
global_tracers = get_tracer_struct();
Kbol = zeros(6);
num_kbol = 1;
BI_Options.file = 'Select a File';
BI_Options.region = 1;
BI_Options.used_default = 0;
BI_Options.prev_tracer = 'None';
BI_Options.used_real = 0;
Custom_Options.method = 'Load .txt File';
Custom_Options.filename = 'Select a file';
Custom_Options.units = 2;
Custom_Options.equation = 'Type an Expression';
Custom_Options.duration = '200';

% Initialize Graph Appearance
box(handles.subgraph2,'off');

% Populate dropdown list of Radiotracers
tracers = get_properties2('all');
tracer_list = 'Select a Radiotracer';
for m=1:length(tracers)
    tracer_list = [tracer_list '|' tracers(m).name];
end
tracer_list = [tracer_list '|' 'Advanced'];
set(handles.radiotracer,'String',tracer_list);

% Populate dropdown lists of Input Functions, Challenges, & Models
inputs = {'Select an Input Function';'Bolus';'Infusion';'Custom'};
set(handles.input,'String',cellstr(inputs));

competitors = {'None'};
set(handles.competition,'String',cellstr(competitors));

%models = {'2-Tissue Compartment';'2-Tissue Irreversible';'1-Tissue Compartment';'B/I Optimization';'SRTM'};
models = {'2-Tissue Compartment';'2-Tissue Irreversible';'1-Tissue Compartment';'SRTM';'Logan Reference';'Bolus/Infusion Optimization'};
set(handles.model,'String',cellstr(models));

% UIWAIT makes pk_sim_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pk_sim_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in live_plot.
function live_plot_Callback(hObject, eventdata, handles)
% hObject    handle to live_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of live_plot

live_plot = get(handles.live_plot,'Value');
if live_plot
    go_Callback(hObject, eventdata, handles)
end


% --- Executes on selection change in model.
function model_Callback(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model

update_menus('model',handles);

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end

initialize_boxes(handles);


% --- Executes during object creation, after setting all properties.
function model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in radiotracer.
function radiotracer_Callback(hObject, eventdata, handles)
% hObject    handle to radiotracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns radiotracer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from radiotracer

update_menus('radiotracer',handles);
    
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function radiotracer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiotracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in competition.
function competition_Callback(hObject, eventdata, handles)
% hObject    handle to competition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns competition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from competition

contents = cellstr(get(handles.competition, 'String'));
competition = contents{get(handles.competition, 'Value')};

initialize_boxes(handles);

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function competition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to competition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from input

update_menus('input',handles);

% Live plotting
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Warning becomes true if a warndlg pops up.  If true, no simulation
warning = 0;

% Get User's selections
contents = cellstr(get(handles.model, 'String'));
model = contents{get(handles.model, 'Value')};

contents = cellstr(get(handles.radiotracer, 'String'));
radiotracer = contents{get(handles.radiotracer, 'Value')};

contents = cellstr(get(handles.input, 'String'));
input = contents{get(handles.input, 'Value')};

contents = cellstr(get(handles.region,'String'));
region = contents{get(handles.region,'Value')};

% Check to make sure all selections are real
if strcmp(radiotracer,'Select a Radiotracer')
    warndlg('Please select a Radiotracer. (Error in pk_sim_gui:go_Callback)', 'No Radiotracer Selected');
    warning = 1;
elseif strcmp(model, 'SRTM')
    disp('1');
elseif strcmp(model, 'Logan Reference')
    disp('2');
elseif strcmp(input, 'Select an Input Function')
    warndlg('Please select an Input Function.  (Error in pk_sim_gui:go_Callback)', 'No Inupt Function Selected');
    warning = 1;
elseif strcmp(input, 'Select a Brain Region')
    warndlg('Please select a Brain Region  (Error in pk_sim_gui:go_Callback)', 'No Brain Region Selected');
    warning = 1;
end

contents = cellstr(get(handles.competition, 'String'));
competition = contents{get(handles.competition, 'Value')};

time = str2num(get(handles.time, 'String'));

noise = str2num(get(handles.noise, 'String'));

num_chal = str2num(get(handles.num_challenges,'String'));

show_chal = get(handles.show_chal,'Value');

chal_times = NaN;
amplitude = NaN;
if num_chal>0
    [chal_times amplitude] = get_challenge_times(num_chal,handles);
    if (chal_times ~= sort(chal_times))
        warndlg('Warning: Your challenge times are out of order.  Please order Challenge Times and any corresponding k3 & k4 values chronologically.  (Error in pk_sim_gui:go_Callback)','Challenge Times Out of Order');
    end
    chal_times = sort(chal_times);

    % Check challenge times
    if chal_times(1)<=1
        warndlg('Challenge times cannot occur at or before 1 min.  (Error in pk_sim_gui:go_Callback)','Challenge Time(s) Out of Range');
        warning = 1;
    elseif chal_times(end) >= time-1
        warndlg('Challenge times must occur at least 2 min. prior to the end of the scan.  Please adjust Challenge Time(s) and/or Scan Time (Error in pk_sim_gui:go_Callback)','Challenge Time(s) Out of Range');
        warning = 1;
    end
end

% Run Simulation
if ~warning
    plot_data = pk_sim_main(model, radiotracer, input, competition, time, noise, chal_times, amplitude, handles);
    plot_results(plot_data,chal_times,handles);
end

% Create an array of the user-entered challenge times
function [chal_times amplitude] = get_challenge_times(num_chal,handles)
    boxes = [handles.c1, handles.c2, handles.c3, handles.c4, handles.c5, handles.c6, handles.c7, handles.c8, handles.c9, handles.c10, handles.c11, handles.c12];
    amp_boxes = [handles.k3_1, handles.k3_2, handles.k3_3, handles.k3_4, handles.k3_5, handles.k3_6, handles.k3_7, handles.k3_8, handles.k3_9, handles.k3_10];
    chal_times = zeros(0,1);
    amplitude = zeros(0,1);
    for m=1:num_chal            
        if ~isempty(get(boxes(m),'String')) && isnumeric(str2num(get(boxes(m),'String')))
            chal_times(end+1,1) = str2num(get(boxes(m),'String'));
            amplitude(end+1,1) = str2num(get(amp_boxes(m),'String'));
        else
            h=warndlg('Challenge times should be integers.  (Error in pk_sim_gui:go_Callback)','Bad Input', 'modal');
        end
    end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get User's selections
contents = cellstr(get(handles.model, 'String'));
model = contents{get(handles.model, 'Value')};

contents = cellstr(get(handles.radiotracer, 'String'));
radiotracer = contents{get(handles.radiotracer, 'Value')};

contents = cellstr(get(handles.input, 'String'));
input = contents{get(handles.input, 'Value')};

contents = cellstr(get(handles.competition, 'String'));
competition = contents{get(handles.competition, 'Value')};

time = str2num(get(handles.time, 'String'));

noise = str2num(get(handles.noise, 'String'));

num_chal = str2num(get(handles.num_challenges,'String'));

show_chal = get(handles.show_chal,'Value');

chal_times = NaN;
amplitude = NaN;
if num_chal>0
    [chal_times amplitude] = get_challenge_times(num_chal,handles);
    chal_times = sort(chal_times);
end

% Run Simulation
plot_data = pk_sim_main(model, radiotracer, input, competition, time, noise, chal_times, amplitude, handles);
% Save Results
save_results(plot_data,chal_times,handles);


function tracer_info_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tracer_info as text
%        str2double(get(hObject,'String')) returns contents of tracer_info as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function tracer_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracer_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in region.
function region_Callback(hObject, eventdata, handles)
% hObject    handle to region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns region contents as cell array
%        contents{get(hObject,'Value')} returns selected item from region

update_menus('region',handles);

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function region_CreateFcn(hObject, eventdata, handles)
% hObject    handle to region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in minus_challenge.
function minus_challenge_Callback(hObject, eventdata, handles)
% hObject    handle to minus_challenge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num_chals = str2num(get(handles.num_challenges,'String'));
if num_chals > 2
    set(handles.num_challenges,'String',num2str(num_chals-1));
    if num_chals <= 10
        set(handles.plus_challenge,'Enable','on');
    end
else
    set(handles.num_challenges,'String',num2str(num_chals-1));
    set(handles.minus_challenge,'Enable','off');
end
num_chals = num_chals-1;
show_boxes(handles);

% Live Plot if decreasing to 0 challenges
% if num_chals == 0
%     if get(handles.live_plot,'Value')
%         go_Callback(hObject, eventdata, handles);
%     end
% end
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in plus_challenge.
function plus_challenge_Callback(hObject, eventdata, handles)
% hObject    handle to plus_challenge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num_chals = str2num(get(handles.num_challenges,'String'));
if  num_chals < 9
    set(handles.num_challenges,'String',num2str(num_chals+1));
    if num_chals >= 0
        set(handles.minus_challenge,'Enable','on');
    end
else
    set(handles.num_challenges,'String',num2str(num_chals+1));
    set(handles.plus_challenge,'Enable','off');
end
num_chals = num_chals+1;
show_boxes(handles);

% Live plot
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end



function num_challenges_Callback(hObject, eventdata, handles)
% hObject    handle to num_challenges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_challenges as text
%        str2double(get(hObject,'String')) returns contents of num_challenges as a double


% --- Executes during object creation, after setting all properties.
function num_challenges_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_challenges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1 as text
%        str2double(get(hObject,'String')) returns contents of c1 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2 as text
%        str2double(get(hObject,'String')) returns contents of c2 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c3_Callback(hObject, eventdata, handles)
% hObject    handle to c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c3 as text
%        str2double(get(hObject,'String')) returns contents of c3 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function c4_Callback(hObject, eventdata, handles)
% hObject    handle to c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c4 as text
%        str2double(get(hObject,'String')) returns contents of c4 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c5_Callback(hObject, eventdata, handles)
% hObject    handle to c5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c5 as text
%        str2double(get(hObject,'String')) returns contents of c5 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c6_Callback(hObject, eventdata, handles)
% hObject    handle to c6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c6 as text
%        str2double(get(hObject,'String')) returns contents of c6 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c7_Callback(hObject, eventdata, handles)
% hObject    handle to c7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c7 as text
%        str2double(get(hObject,'String')) returns contents of c7 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c8_Callback(hObject, eventdata, handles)
% hObject    handle to c8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c8 as text
%        str2double(get(hObject,'String')) returns contents of c8 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function c9_Callback(hObject, eventdata, handles)
% hObject    handle to c9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c9 as text
%        str2double(get(hObject,'String')) returns contents of c9 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c10_Callback(hObject, eventdata, handles)
% hObject    handle to c10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c10 as text
%        str2double(get(hObject,'String')) returns contents of c10 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function c11_Callback(hObject, eventdata, handles)
% hObject    handle to c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c11 as text
%        str2double(get(hObject,'String')) returns contents of c11 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c12_Callback(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c12 as text
%        str2double(get(hObject,'String')) returns contents of c12 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function c12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k1_Callback(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k1 as text
%        str2double(get(hObject,'String')) returns contents of k1 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k2_Callback(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k2 as text
%        str2double(get(hObject,'String')) returns contents of k2 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_Callback(hObject, eventdata, handles)
% hObject    handle to k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3 as text
%        str2double(get(hObject,'String')) returns contents of k3 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_Callback(hObject, eventdata, handles)
% hObject    handle to k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4 as text
%        str2double(get(hObject,'String')) returns contents of k4 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp1_Callback(hObject, eventdata, handles)
% hObject    handle to kp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp1 as text
%        str2double(get(hObject,'String')) returns contents of kp1 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp2_Callback(hObject, eventdata, handles)
% hObject    handle to kp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp2 as text
%        str2double(get(hObject,'String')) returns contents of kp2 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp3_Callback(hObject, eventdata, handles)
% hObject    handle to kp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp3 as text
%        str2double(get(hObject,'String')) returns contents of kp3 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp4_Callback(hObject, eventdata, handles)
% hObject    handle to kp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp4 as text
%        str2double(get(hObject,'String')) returns contents of kp4 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kp4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kr1_Callback(hObject, eventdata, handles)
% hObject    handle to kr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kr1 as text
%        str2double(get(hObject,'String')) returns contents of kr1 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kr1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kr2_Callback(hObject, eventdata, handles)
% hObject    handle to kr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kr2 as text
%        str2double(get(hObject,'String')) returns contents of kr2 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kend1_Callback(hObject, eventdata, handles)
% hObject    handle to kend1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kend1 as text
%        str2double(get(hObject,'String')) returns contents of kend1 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kend1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kend1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kend2_Callback(hObject, eventdata, handles)
% hObject    handle to kend2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kend2 as text
%        str2double(get(hObject,'String')) returns contents of kend2 as a double

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function kend2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kend2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tracer_name_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tracer_name as text
%        str2double(get(hObject,'String')) returns contents of tracer_name as a double


% --- Executes during object creation, after setting all properties.
function tracer_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracer_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ref_tissue_Callback(hObject, eventdata, handles)
% hObject    handle to ref_tissue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_tissue as text
%        str2double(get(hObject,'String')) returns contents of ref_tissue as a double


% --- Executes during object creation, after setting all properties.
function ref_tissue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ref_tissue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tracer_literature_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_literature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tracer_literature as text
%        str2double(get(hObject,'String')) returns contents of tracer_literature as a double


% --- Executes during object creation, after setting all properties.
function tracer_literature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracer_literature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_chal.
function show_chal_Callback(hObject, eventdata, handles)
% hObject    handle to show_chal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_chal
    go_Callback(hObject,eventdata,handles);


% --- Executes on selection change in active_comp.
function active_comp_Callback(hObject, eventdata, handles)
% hObject    handle to active_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns active_comp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from active_comp

if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function active_comp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to active_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_pulse.
function plot_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_pulse
go_Callback(hObject, eventdata, handles);



function k3_2_Callback(hObject, eventdata, handles)
% hObject    handle to k3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_2 as text
%        str2double(get(hObject,'String')) returns contents of k3_2 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_3_Callback(hObject, eventdata, handles)
% hObject    handle to k3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_3 as text
%        str2double(get(hObject,'String')) returns contents of k3_3 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_4_Callback(hObject, eventdata, handles)
% hObject    handle to k3_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_4 as text
%        str2double(get(hObject,'String')) returns contents of k3_4 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_2_Callback(hObject, eventdata, handles)
% hObject    handle to k4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_2 as text
%        str2double(get(hObject,'String')) returns contents of k4_2 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_3_Callback(hObject, eventdata, handles)
% hObject    handle to k4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_3 as text
%        str2double(get(hObject,'String')) returns contents of k4_3 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_4_Callback(hObject, eventdata, handles)
% hObject    handle to k4_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_4 as text
%        str2double(get(hObject,'String')) returns contents of k4_4 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_1_Callback(hObject, eventdata, handles)
% hObject    handle to k3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_1 as text
%        str2double(get(hObject,'String')) returns contents of k3_1 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_5_Callback(hObject, eventdata, handles)
% hObject    handle to k3_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_5 as text
%        str2double(get(hObject,'String')) returns contents of k3_5 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_6_Callback(hObject, eventdata, handles)
% hObject    handle to k3_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_6 as text
%        str2double(get(hObject,'String')) returns contents of k3_6 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_7_Callback(hObject, eventdata, handles)
% hObject    handle to k3_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_7 as text
%        str2double(get(hObject,'String')) returns contents of k3_7 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_8_Callback(hObject, eventdata, handles)
% hObject    handle to k3_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_8 as text
%        str2double(get(hObject,'String')) returns contents of k3_8 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_9_Callback(hObject, eventdata, handles)
% hObject    handle to k3_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_9 as text
%        str2double(get(hObject,'String')) returns contents of k3_9 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_10_Callback(hObject, eventdata, handles)
% hObject    handle to k3_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3_10 as text
%        str2double(get(hObject,'String')) returns contents of k3_10 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k3_10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_5_Callback(hObject, eventdata, handles)
% hObject    handle to k4_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_5 as text
%        str2double(get(hObject,'String')) returns contents of k4_5 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_6_Callback(hObject, eventdata, handles)
% hObject    handle to k4_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_6 as text
%        str2double(get(hObject,'String')) returns contents of k4_6 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_7_Callback(hObject, eventdata, handles)
% hObject    handle to k4_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_7 as text
%        str2double(get(hObject,'String')) returns contents of k4_7 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_8_Callback(hObject, eventdata, handles)
% hObject    handle to k4_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_8 as text
%        str2double(get(hObject,'String')) returns contents of k4_8 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_9_Callback(hObject, eventdata, handles)
% hObject    handle to k4_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_9 as text
%        str2double(get(hObject,'String')) returns contents of k4_9 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_10_Callback(hObject, eventdata, handles)
% hObject    handle to k4_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_10 as text
%        str2double(get(hObject,'String')) returns contents of k4_10 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end



% --- Executes during object creation, after setting all properties.
function k4_10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k4_1_Callback(hObject, eventdata, handles)
% hObject    handle to k4_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k4_1 as text
%        str2double(get(hObject,'String')) returns contents of k4_1 as a double
if get(handles.live_plot,'Value')
    go_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function k4_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k4_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in import_txt.
function import_txt_Callback(hObject, eventdata, handles)
% hObject    handle to import_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pressed_ok;
pressed_ok = false; % Tells if user finished the custom_import process or exited prematurely

% custom_import global variable contains the matrix of custom AIF data
global custom_input;

h = custom_input_gui(); % This gui helps the user prepare a custom AIF
uiwait(h);

% Time-frame is reset to reflect the new custom AIF
set(handles.time,'String',num2str(floor(custom_input(end,1))));
%set(handles.time,'Enable','off');

if pressed_ok
    message = ['Data successfully imported.  Scan Time = ' num2str(floor(custom_input(end,1))) ' minutes'];
    msgbox(message, 'Import Successful');
    go_Callback(hObject,eventdata,handles);
end


% --- Executes on button press in set_k_bol.
function set_k_bol_Callback(hObject, eventdata, handles)
% hObject    handle to set_k_bol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tissue_tac;
contents = cellstr(get(handles.radiotracer,'String'));
radiotracer = contents{get(handles.radiotracer,'Value')};
time = str2num(get(handles.time,'String'));
if strcmp(radiotracer,'Select a Radiotracer')
    warndlg('Please Select a Radiotracer (Error in pk_sim_gui:set_k_bol_Callback)', 'No Radiotracer Selected');
else
    uiwait(B_I_Options_gui(radiotracer,time));
    %Set the scan time based on the bolus TAC time
    tlen = tissue_tac(1,end);
    set(handles.time,'String',num2str(floor(tlen)));
    go_Callback(hObject,eventdata,handles);
end




% --- Executes on button press in minus_tracer.
function minus_tracer_Callback(hObject, eventdata, handles)
% hObject    handle to minus_tracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Subtract 1 from num_tracers, but don't go below 1
set(handles.plus_tracer,'Enable','on');
num_tracers = str2num(get(handles.num_tracers,'String'));

set(handles.num_tracers,'String',num2str(num_tracers-1));

num_tracers = str2num(get(handles.num_tracers,'String'));
if num_tracers <= 1
    set(handles.minus_tracer,'Enable','off');
end

% Populate List in Current Tracer
if num_tracers == 1
    set(handles.current_tracer,'String',{'1'});
    set(handles.current_tracer,'Value',1);
elseif num_tracers == 2
    set(handles.current_tracer,'String',{'1','2'});
    set(handles.current_tracer,'Value',1);
elseif num_tracers == 3
    set(handles.current_tracer,'String',{'1','2','3'});
    set(handles.current_tracer,'Value',1);
end


% --- Executes on button press in plus_tracer.
function plus_tracer_Callback(hObject, eventdata, handles)
% hObject    handle to plus_tracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add 1 to num_tracers, but don't go above 3
set(handles.minus_tracer,'Enable','on');
num_tracers = str2num(get(handles.num_tracers,'String'));

set(handles.num_tracers,'String',num2str(num_tracers+1));

num_tracers = str2num(get(handles.num_tracers,'String'));
if num_tracers >= 3
    set(handles.plus_tracer,'Enable','off');
end

% Populate List in Current Tracer
if num_tracers == 1
    set(handles.current_tracer,'String',{'1'});
    set(handles.current_tracer,'Value',1);
elseif num_tracers == 2
    set(handles.current_tracer,'String',{'1','2'});
    set(handles.current_tracer,'Value',1);
elseif num_tracers == 3
    set(handles.current_tracer,'String',{'1','2','3'});
    set(handles.current_tracer,'Value',1);
end


function num_tracers_Callback(hObject, eventdata, handles)
% hObject    handle to num_tracers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_tracers as text
%        str2double(get(hObject,'String')) returns contents of num_tracers as a double


% --- Executes during object creation, after setting all properties.
function num_tracers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_tracers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in current_tracer.
function current_tracer_Callback(hObject, eventdata, handles)
% hObject    handle to current_tracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns current_tracer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from current_tracer

global preferences;
tracer = get(handles.current_tracer,'Value');

if tracer == 1
    if isfield(preferences,'tracer1');
        disp('Found Tracer1');
        guidata(pk_sim_gui,preferences.tracer1);
    end
elseif tracer == 2
    if isfield(preferences,'tracer2')
        disp('Found Tracer2');
        guidata(pk_sim_gui,preferences.tracer2);
    end
elseif tracer == 3
    if isfield(preferences,'tracer3')
        disp('Found Tracer3');
        guidata(pk_sim_gui,preferences.tracer3);
    end
end


% --- Executes during object creation, after setting all properties.
function current_tracer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_tracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_tracer_preferences.
function set_tracer_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to set_tracer_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global preferences;
% contents = str2num(get(handles.current_tracer,'String'));
% tracer = contents{get(handles.current_tracer,'Value')};
tracer = get(handles.current_tracer,'Value');

if tracer == 1
    preferences.tracer1 = guidata(pk_sim_gui);
elseif tracer == 2
    preferences.tracer2 = guidata(pk_sim_gui);
elseif tracer == 3
    preferences.tracer3 = guidata(pk_sim_gui);
end


% --- Executes on button press in SRTM_wizard.
function SRTM_wizard_Callback(hObject, eventdata, handles)
% hObject    handle to SRTM_wizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global roi_tac reference_tac;

contents = cellstr(get(handles.radiotracer,'String'));
radiotracer = contents{get(handles.radiotracer,'Value')};

active_comp_contents = cellstr(get(handles.active_comp,'String'));
active_comp_value = get(handles.active_comp,'Value');

if strcmp(radiotracer,'Select a Radiotracer')
    warndlg('Please Select a Radiotracer','No Radiotracer Selected');
else
    h = SRTM_wizard_gui(radiotracer,active_comp_contents,active_comp_value);
    uiwait(h);
    set(handles.time,'String', num2str(roi_tac(1,end)));
%     assignin('base','roi_tac',roi_tac);
%     assignin('base','reference_tac',reference_tac);
    go_Callback(hObject,eventdata,handles);
end

%% Changes the visibility of lines on the graph
% --- Executes on button press in plotline1.
function plotline1_Callback(hObject, eventdata, handles)
% hObject    handle to plotline1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline1
global l1;
checked = get(handles.plotline1,'Value');

if checked
    set(l1,'Visible','on');
else
    set(l1,'Visible','off');
end

% --- Executes on button press in plotline2.
function plotline2_Callback(hObject, eventdata, handles)
% hObject    handle to plotline2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline2
global l2;
checked = get(handles.plotline2,'Value');

if checked
    set(l2,'Visible','on');
else
    set(l2,'Visible','off');
end

% --- Executes on button press in plotline3.
function plotline3_Callback(hObject, eventdata, handles)
% hObject    handle to plotline3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline3
global l3;
checked = get(handles.plotline3,'Value');

if checked
    set(l3,'Visible','on');
else
    set(l3,'Visible','off');
end

% --- Executes on button press in plotline4.
function plotline4_Callback(hObject, eventdata, handles)
% hObject    handle to plotline4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline4
global l4;
checked = get(handles.plotline4,'Value');

if checked
    set(l4,'Visible','on');
else
    set(l4,'Visible','off');
end

% --- Executes on button press in plotline5.
function plotline5_Callback(hObject, eventdata, handles)
% hObject    handle to plotline5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline5
global l5;
checked = get(handles.plotline5,'Value');

if checked
    set(l5,'Visible','on');
else
    set(l5,'Visible','off');
end

% --- Executes on button press in plotline6.
function plotline6_Callback(hObject, eventdata, handles)
% hObject    handle to plotline6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotline6
global l6;
checked = get(handles.plotline6,'Value');

if checked
    set(l6,'Visible','on');
else
    set(l6,'Visible','off');
end


% --- Executes on selection change in noise_type.
function noise_type_Callback(hObject, eventdata, handles)
% hObject    handle to noise_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns noise_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noise_type


% --- Executes during object creation, after setting all properties.
function noise_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fit_data.
function fit_data_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_data


% --- Executes on button press in logan_wizard.
function logan_wizard_Callback(hObject, eventdata, handles)
% hObject    handle to logan_wizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global roi_tac reference_tac;

contents = cellstr(get(handles.radiotracer,'String'));
radiotracer = contents{get(handles.radiotracer,'Value')};

active_comp_contents = cellstr(get(handles.active_comp,'String'));
active_comp_value = get(handles.active_comp,'Value');

if strcmp(radiotracer,'Select a Radiotracer')
    warndlg('Please Select a Radiotracer','No Radiotracer Selected');
else
    h = logan_wizard_gui(radiotracer,active_comp_contents,active_comp_value);
    uiwait(h);
    set(handles.time,'String', num2str(roi_tac(1,end)));
%     assignin('base','roi_tac',roi_tac);
%     assignin('base','reference_tac',reference_tac);
    go_Callback(hObject,eventdata,handles);
end
