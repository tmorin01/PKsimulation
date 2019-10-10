% GUI Script to set B/I parameters in PK Simulation
% 
% Author: Tom Morin
% Date: July 2015
%
function varargout = B_I_Options_gui(varargin)
% B_I_OPTIONS_GUI MATLAB code for B_I_Options_gui.fig
%      B_I_OPTIONS_GUI, by itself, creates a new B_I_OPTIONS_GUI or raises the existing
%      singleton*.
%
%      H = B_I_OPTIONS_GUI returns the handle to a new B_I_OPTIONS_GUI or the handle to
%      the existing singleton*.
%
%      B_I_OPTIONS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in B_I_OPTIONS_GUI.M with the given input arguments.
%
%      B_I_OPTIONS_GUI('Property','Value',...) creates a new B_I_OPTIONS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before B_I_Options_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to B_I_Options_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help B_I_Options_gui

% Last Modified by GUIDE v2.5 04-Aug-2015 10:37:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @B_I_Options_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @B_I_Options_gui_OutputFcn, ...
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


% --- Executes just before B_I_Options_gui is made visible.
function B_I_Options_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to B_I_Options_gui (see VARARGIN)

% **********
global num_kbol Kbol BI_Options tissue_tac;

% Choose default command line output for B_I_Options_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Get the selected Radiotracer & Scan Time from the Main GUI
setappdata(handles.radiotracer,'radiotracer',varargin(1));
setappdata(handles.time,'time',varargin(2));
radiotracer = getappdata(handles.radiotracer,'radiotracer');
time = getappdata(handles.time,'time');
set(handles.radiotracer,'String',radiotracer);
set(handles.time,'String',time);



% Set num_kbol to previously used value & show correct # of Kbol boxes
set(handles.num_kbol,'String',num2str(num_kbol));
if num_kbol == 1
    set(handles.minus_kbol,'Enable','off');
    set(handles.plus_kbol,'Enable','on');
elseif num_kbol == 6
    set(handles.minus_kbol,'Enable','on');
    set(handles.plus_kbol,'Enable','off');
else
    set(handles.minus_kbol,'Enable','on');
    set(handles.plus_kbol,'Enable','on');
end

% Set Kbol Values to previously used values
boxes = [handles.kbol1, handles.kbol2, handles.kbol3, handles.kbol4, handles.kbol5, handles.kbol6];
for m=1:length(boxes)
    set(boxes(m),'String',Kbol(m));
    if m <= num_kbol
        set(boxes(m),'Visible','on');
    else
        set(boxes(m),'Visible','off');
    end
end

% Set Brain Region & bolus curve file to previously used values
if strcmp(BI_Options.prev_tracer,radiotracer)
    set(handles.real_data,'Value',BI_Options.used_real);
    disp(BI_Options.used_real);
    disp('^ Used real?');
    if BI_Options.used_real
        if ~BI_Options.used_default
            set(handles.file,'Enable','on');
            set(handles.get_file,'Enable','on');
            set(handles.file,'String',BI_Options.file);
            input = importdata(fullfile(BI_Options.file),'\t',1);
            regions = input.textdata{1};
            regions = regexprep(regions,'\t','|');
            set(handles.brain_region,'String',regions);
            set(handles.brain_region,'Value',BI_Options.region);
            tissue_tac(1,:) = input.data(:,1)'./60;
            tissue_tac(2,:) = input.data(:,get(handles.brain_region,'Value'))';
        else
            tissue_tac = get_default_TAC(handles,radiotracer,BI_Options.region);
        end        
        set(handles.brain_region,'Value',BI_Options.region);
    else
        set(handles.file,'Enable','off');
        set(handles.get_file,'Enable','off');
    end
        
else
    tissue_tac = get_default_TAC(handles,radiotracer,BI_Options.region);
    set(handles.brain_region,'Value',1);
end

BI_Options.prev_tracer = radiotracer;
real_data_Callback(hObject, eventdata, handles);


% UIWAIT makes B_I_Options_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = B_I_Options_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function k_bol_Callback(hObject, eventdata, handles)
% hObject    handle to k_bol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_bol as text
%        str2double(get(hObject,'String')) returns contents of k_bol as a double


% --- Executes during object creation, after setting all properties.
function k_bol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_bol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This is the "Continue" button.
global Kbol num_kbol BI_Options tisue_tac;

% Get Kbol Values
boxes = [handles.kbol1, handles.kbol2, handles.kbol3, handles.kbol4, handles.kbol5, handles.kbol6];
num_kbol = str2num(get(handles.num_kbol,'String'));
for m=1:num_kbol
    Kbol(m) = str2num(get(boxes(m),'String'));
end
        
% Warning if text file unreadable.  Otherwise, continue.
file = cellstr(get(handles.file,'String'));
if get(handles.real_data,'Value')
    if exist(file{1},'file')
        BI_Options.used_real = 1;
        % Close the window
        close(gcf);
    else
        warndlg('Click "Browse" to choose a TAC file. (Error in B_I_Options_gui:ok_Callback)', 'TAC File does not exist.');
    end
else
    BI_Options.used_real = 0;
    close(gcf);
    % SIMULATE TISSUE CURVES!
end

function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file as text
%        str2double(get(hObject,'String')) returns contents of file as a double


% --- Executes during object creation, after setting all properties.
function file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_file.
function get_file_Callback(hObject, eventdata, handles)
% hObject    handle to get_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tissue_tac Kbol num_kbol BI_Options;

[filename, pathname] = uigetfile('*.*','Select a TAC Data File');
set(handles.file,'String',[pathname,filename]);

input = importdata(fullfile(pathname,filename),'\t',1);
regions = input.textdata{1};
regions = regexprep(regions,'\t','|');
set(handles.brain_region,'String',regions);
set(handles.brain_region,'Value',1);
BI_Options.region = get(handles.brain_region,'Value');
BI_Options.file = get(handles.file,'String');

num_kbol = str2num(get(handles.num_kbol,'String'));
boxes = [handles.kbol1, handles.kbol2, handles.kbol3, handles.kbol4, handles.kbol5, handles.kbol6];
for m=1:num_kbol
    Kbol(m) = str2num(get(boxes(m),'String'));
end

tissue_tac = zeros(2,length(input.data));
tissue_tac(1,:) = input.data(:,1)'./60;
tissue_tac(2,:) = input.data(:,get(handles.brain_region,'Value'))';


% --- Executes on button press in real_data.
function real_data_Callback(hObject, eventdata, handles)
% hObject    handle to real_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of real_data
global tissue_tac;

checked = get(handles.real_data,'Value');
radiotracer = getappdata(handles.radiotracer,'radiotracer');
region = get(handles.brain_region,'Value');

if checked
    set(handles.file,'Enable','on');
    set(handles.get_file,'Enable','on');
    set(handles.real_data,'String','Using Real Data')
    set(handles.time,'Enable','off');
    get_default_TAC(handles,radiotracer,region);
            
    filename = cellstr(get(handles.file,'String'));
    if exist(filename{1},'file')
        input = importdata(filename{1},'\t',1);
        regions = input.textdata{1};
        regions = regexprep(regions,'\t','|');
        set(handles.brain_region,'String',regions);
        set(handles.brain_region,'Value',1);
    end
else
    set(handles.file,'Enable','off');
    set(handles.get_file,'Enable','off');
    set(handles.real_data,'String','Using Simulated Data');
    set(handles.time,'Enable','on')
    set(handles.time,'String','90');
    
    % Get Brain Regions
    tracer_props = get_properties2(radiotracer);
    model = tracer_props.TwoTC;
    regions = get_available_brain_regions(model);
    set(handles.brain_region,'String',regions);
    
    % Get tissue_tac
    contents = cellstr(get(handles.brain_region,'String'));
    brain_region = contents{get(handles.brain_region,'Value')};
    k_vals = get_region_props(model, brain_region);
    temp = cellstr(get(handles.time,'String'));
    time = str2num(temp{1});
    t = [0:0.5:time];
    Ca = get_InputFunc(handles,'Bolus',t);
    assignin('base','Ca',Ca);
    tissue_tac = zeros(2,length(t));
    tissue_tac = run_2TC_model(tracer_props,1,time, Ca, 'Two Tissue', k_vals, 1, 'B/I Optimization');
    assignin('base','tissue_tac',tissue_tac);
end



function kbol1_Callback(hObject, eventdata, handles)
% hObject    handle to kbol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol1 as text
%        str2double(get(hObject,'String')) returns contents of kbol1 as a double


% --- Executes during object creation, after setting all properties.
function kbol1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kbol2_Callback(hObject, eventdata, handles)
% hObject    handle to kbol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol2 as text
%        str2double(get(hObject,'String')) returns contents of kbol2 as a double


% --- Executes during object creation, after setting all properties.
function kbol2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kbol3_Callback(hObject, eventdata, handles)
% hObject    handle to kbol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol3 as text
%        str2double(get(hObject,'String')) returns contents of kbol3 as a double


% --- Executes during object creation, after setting all properties.
function kbol3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kbol4_Callback(hObject, eventdata, handles)
% hObject    handle to kbol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol4 as text
%        str2double(get(hObject,'String')) returns contents of kbol4 as a double


% --- Executes during object creation, after setting all properties.
function kbol4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kbol5_Callback(hObject, eventdata, handles)
% hObject    handle to kbol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol5 as text
%        str2double(get(hObject,'String')) returns contents of kbol5 as a double


% --- Executes during object creation, after setting all properties.
function kbol5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kbol6_Callback(hObject, eventdata, handles)
% hObject    handle to kbol6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol6 as text
%        str2double(get(hObject,'String')) returns contents of kbol6 as a double


% --- Executes during object creation, after setting all properties.
function kbol6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_kbol_Callback(hObject, eventdata, handles)
% hObject    handle to num_kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_kbol as text
%        str2double(get(hObject,'String')) returns contents of num_kbol as a double


% --- Executes during object creation, after setting all properties.
function num_kbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in minus_kbol.
function minus_kbol_Callback(hObject, eventdata, handles)
% hObject    handle to minus_kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boxes = [handles.kbol1, handles.kbol2, handles.kbol3, handles.kbol4, handles.kbol5, handles.kbol6];
num_kbol = str2num(get(handles.num_kbol,'String'));
set(boxes(num_kbol),'Visible','off');
if num_kbol == 2
    set(handles.minus_kbol,'Enable','off');
end
num_kbol = num_kbol - 1;
if num_kbol < 6
    set(handles.plus_kbol,'Enable','on');
end
set(handles.num_kbol,'String',num2str(num_kbol));


% --- Executes on button press in plus_kbol.
function plus_kbol_Callback(hObject, eventdata, handles)
% hObject    handle to plus_kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boxes = [handles.kbol1, handles.kbol2, handles.kbol3, handles.kbol4, handles.kbol5, handles.kbol6];
num_kbol = str2num(get(handles.num_kbol,'String'));
if num_kbol == 5
    set(handles.plus_kbol,'Enable','off')
end
num_kbol = num_kbol + 1;
set(boxes(num_kbol),'Visible','on');
if num_kbol > 1
    set(handles.minus_kbol,'Enable','on');
end
set(handles.num_kbol,'String',num2str(num_kbol));



% --- Executes on selection change in brain_region.
function brain_region_Callback(hObject, eventdata, handles)
% hObject    handle to brain_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns brain_region contents as cell array
%        contents{get(hObject,'Value')} returns selected item from brain_region

checked = get(handles.real_data,'Value');
if checked
    global tissue_tac BI_Options;
    
    BI_Options.region = get(handles.brain_region,'Value');
    input = importdata(get(handles.file,'String'),'\t',1);
    
    assignin('base','input',input);
    
    tissue_tac(1,:) = input.data(:,1)'./60;
    tissue_tac(2,:) = input.data(:,get(handles.brain_region,'Value'))';
end


% --- Executes during object creation, after setting all properties.
function brain_region_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brain_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radiotracer_Callback(hObject, eventdata, handles)
% hObject    handle to radiotracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radiotracer as text
%        str2double(get(hObject,'String')) returns contents of radiotracer as a double


% --- Executes during object creation, after setting all properties.
function radiotracer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiotracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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

function region_props = get_region_props(model,region)
if strcmp(region, 'Select a Brain Region')
    region_props = NaN;
    warndlg('Please select a brain region.');
elseif strcmp(region, 'General')
    region_props = model.k.general;
elseif strcmp(region, 'Frontal Lobe')
    region_props = model.k.frontal;
elseif strcmp(region, 'Thalamus')
    region_props = model.k.thalamus;
elseif strcmp(region, 'Striatum')
    region_props = model.k.striatum;
elseif strcmp(region, 'Anterior Cortex')
    region_props = model.k.ant_cx;
elseif strcmp(region, 'Posterior Cortex')
    region_props = model.k.post_cx;
elseif strcmp(region, 'Hippocampus')
    region_props = model.k.hippocampus;
elseif strcmp(region, 'Medulla')
    region_props = model.k.medulla;
elseif strcmp(region, 'Spinal Cord')
    region_props = model.k.spinal_cord;
end
