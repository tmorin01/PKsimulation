function varargout = radiotracer_options_gui(varargin)
% RADIOTRACER_OPTIONS_GUI MATLAB code for radiotracer_options_gui.fig
%      RADIOTRACER_OPTIONS_GUI, by itself, creates a new RADIOTRACER_OPTIONS_GUI or raises the existing
%      singleton*.
%
%      H = RADIOTRACER_OPTIONS_GUI returns the handle to a new RADIOTRACER_OPTIONS_GUI or the handle to
%      the existing singleton*.
%
%      RADIOTRACER_OPTIONS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADIOTRACER_OPTIONS_GUI.M with the given input arguments.
%
%      RADIOTRACER_OPTIONS_GUI('Property','Value',...) creates a new RADIOTRACER_OPTIONS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before radiotracer_options_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to radiotracer_options_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help radiotracer_options_gui

% Last Modified by GUIDE v2.5 21-Jul-2015 14:56:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @radiotracer_options_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @radiotracer_options_gui_OutputFcn, ...
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


% --- Executes just before radiotracer_options_gui is made visible.
function radiotracer_options_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to radiotracer_options_gui (see VARARGIN)

% Choose default command line output for radiotracer_options_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes radiotracer_options_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Populate dropdown tracer_lst
tracers = get_properties2('all');
tracer_list = 'Select a Radiotracer';
for m=1:length(tracers)
    tracer_list = [tracer_list '|' tracers(m).name];
end
tracer_list = [tracer_list '|' 'Add New Tracer'];
set(handles.tracer_lst,'String',tracer_list);


% --- Outputs from this function are returned to the command line.
function varargout = radiotracer_options_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lit_ref_Callback(hObject, eventdata, handles)
% hObject    handle to lit_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lit_ref as text
%        str2double(get(hObject,'String')) returns contents of lit_ref as a double


% --- Executes during object creation, after setting all properties.
function lit_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lit_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reference_tissue_Callback(hObject, eventdata, handles)
% hObject    handle to reference_tissue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reference_tissue as text
%        str2double(get(hObject,'String')) returns contents of reference_tissue as a double


% --- Executes during object creation, after setting all properties.
function reference_tissue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reference_tissue (see GCBO)
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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tac_path_Callback(hObject, eventdata, handles)
% hObject    handle to tac_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tac_path as text
%        str2double(get(hObject,'String')) returns contents of tac_path as a double


% --- Executes during object creation, after setting all properties.
function tac_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tac_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tracer_type.
function tracer_type_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tracer_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tracer_type


% --- Executes during object creation, after setting all properties.
function tracer_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracer_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global region_rates;

contents = cellstr(get(handles.tracer_lst,'String'));
radiotracer = contents(get(handles.tracer_lst,'Value'));
val = get(handles.tracer_lst,'Value');

r.OneTC.k = region_rates(val).OneTC.k;
r.TwoTC.k = region_rates(val).TwoTC.k;

r.name = get(handles.name,'String');
r.ref = get(handles.lit_ref,'String');
r.ref_tissue = get(handles.reference_tissue,'String');
m=1;
if get(handles.C11,'Value')
    r.compounds{m} = 'C-11';
    m=m+1;
end
if get(handles.F18,'Value')
    r.compounds{m} = 'F-18';
    m=m+1;
end
if get(handles.O15,'Value')
    r.compounds{m} = 'O-15';
end
r.available_areas = cellstr(get(handles.region,'String'));
if strcmp('NaN',(get(handles.kp1,'String')))
    r.kp = NaN;
else
    r.kp(1) = str2num(get(handles.kp1,'String'));
    r.kp(2) = str2num(get(handles.kp2,'String'));
    r.kp(3) = str2num(get(handles.kp3,'String'));
    r.kp(4) = str2num(get(handles.kp4,'String'));
end
if strcmp('NaN',get(handles.kr1,'String'))
    r.kr = NaN;
else
    r.kr(1) = str2num(get(handles.kr1,'String'));
    r.kr(2) = str2num(get(handles.kr2,'String'));
end
if strcmp('NaN',get(handles.kda1,'String'))
    r.k_da = NaN;
else
    r.k_da(1) = str2num(get(handles.kda1,'String'));
    r.k_da(2) = str2num(get(handles.kda2,'String'));
end

r.bolus_curve = get(handles.tac_path,'String');

make_txt_file(r);

close(gcf);


% --- Executes on selection change in tracer_lst.
function tracer_lst_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tracer_lst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tracer_lst

global region_rates;

contents = cellstr(get(handles.tracer_lst,'String'));

for m=2:(length(contents)-1)
    radiotracer = contents(m);
    tracer_props = get_properties2(radiotracer);
    region_rates(m).TwoTC = tracer_props.TwoTC;
    region_rates(m).OneTC = tracer_props.OneTC;
end
region_rates(end).TwoTC.k.general = NaN;
region_rates(end).OneTC.k.general = NaN;
assignin('base','region_rates',region_rates);

radiotracer = contents(get(handles.tracer_lst,'Value'));
if ~strncmp(radiotracer, 'Add', 3)
    tracer_props = get_properties2(radiotracer);
    
    set(handles.name,'String',tracer_props.name);
    set(handles.lit_ref,'String',tracer_props.ref);
    set(handles.reference_tissue,'String',tracer_props.ref_tissue);
    set(handles.tac_path,'String',tracer_props.bolus_curve);
    temp = strfind(tracer_props.compounds,'C-11');
    a = cell2mat(temp);
    if any(a)
        set(handles.C11,'Value',1);
    else
        set(handles.C11,'Value',0);
    end
    temp = strfind(tracer_props.compounds,'F-18');
    a = cell2mat(temp);
    if any(a)
        set(handles.F18,'Value',1);
    else
        set(handles.F18,'Value',0);
    end
    temp = strfind(tracer_props.compounds,'O-15');
    a = cell2mat(temp);
    if any(a)
        set(handles.O15,'Value',1);
    else
        set(handles.O15,'Value',0);
    end
    
    fields = {'kp1';'kp2';'kp3';'kp4'};
    for m=1:length(fields)
        if ~isnan(tracer_props.kp(1))
            set(handles.(fields{m}),'String',num2str(tracer_props.kp(m)));
        else
            set(handles.(fields{m}),'String','NaN');
        end
    end
    
    fields = {'kr1';'kr2';};
    for m=1:length(fields)
        if ~isnan(tracer_props.kr(1))
            set(handles.(fields{m}),'String',num2str(tracer_props.kr(m)));
        else
            set(handles.(fields{m}),'String','NaN');
        end
    end
    
    fields = {'kda1';'kda2'};
    for m=1:length(fields)
        if ~isnan(tracer_props.k_da(1))
            set(handles.(fields{m}),'String',num2str(tracer_props.k_da(m)));
        else
            set(handles.(fields{m}),'String','NaN');
        end
    end
    
    set_brain_regions(handles,tracer_props);
    
else
    set(handles.name,'String','New Radiotracer Name');
    set(handles.lit_ref,'String','Reference to Literature');
    set(handles.reference_tissue,'String','Reference Tissue');
    set(handles.tac_path,'String','Directory of TAC Data File');
    set(handles.C11,'Value',0);
    set(handles.F18,'Value',0);
    set(handles.O15,'Value',0);
    fields = {'kp1';'kp2';'kp3';'kp4';'kr1';'kr2';'kda1';'kda2';'k1';'k2';'k3';'k4'};
    for m=1:length(fields)
        set(handles.(fields{m}),'String','NaN');
    end
    set(handles.region,'String','general');
end


% --- Executes during object creation, after setting all properties.
function tracer_lst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tracer_lst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in C11.
function C11_Callback(hObject, eventdata, handles)
% hObject    handle to C11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of C11


% --- Executes on button press in F18.
function F18_Callback(hObject, eventdata, handles)
% hObject    handle to F18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of F18


% --- Executes on button press in O15.
function O15_Callback(hObject, eventdata, handles)
% hObject    handle to O15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of O15


% --- Executes on button press in tac_browse.
function tac_browse_Callback(hObject, eventdata, handles)
% hObject    handle to tac_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.*');
path = fullfile(pathname,filename);
set(handles.tac_path,'String',path);



function kp2_Callback(hObject, eventdata, handles)
% hObject    handle to kp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp2 as text
%        str2double(get(hObject,'String')) returns contents of kp2 as a double


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



function kda1_Callback(hObject, eventdata, handles)
% hObject    handle to kda1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kda1 as text
%        str2double(get(hObject,'String')) returns contents of kda1 as a double


% --- Executes during object creation, after setting all properties.
function kda1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kda1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kda2_Callback(hObject, eventdata, handles)
% hObject    handle to kda2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kda2 as text
%        str2double(get(hObject,'String')) returns contents of kda2 as a double


% --- Executes during object creation, after setting all properties.
function kda2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kda2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in model.
function model_Callback(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from model

contents = cellstr(get(handles.tracer_lst,'String'));
radiotracer = contents(get(handles.tracer_lst,'Value'));

if ~strncmp(radiotracer,'Add',3)
    tracer_props = get_properties2(radiotracer);
    set_brain_regions(handles,tracer_props);
else
    contents = cellstr(get(handles.model,'String'));
    model = contents(get(handles.model,'Value'));
    if strncmp(model,'One',3)
        set(handles.k3,'Visible','off');
        set(handles.k4,'Visible','off');
    else
        set(handles.k3,'Visible','on');
        set(handles.k4,'Visible','on');
    end        
end


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


% --- Executes on selection change in region.
function region_Callback(hObject, eventdata, handles)
% hObject    handle to region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns region contents as cell array
%        contents{get(hObject,'Value')} returns selected item from region

contents = cellstr(get(handles.tracer_lst,'String'));
radiotracer = contents(get(handles.tracer_lst,'Value'));

if ~strncmp(radiotracer,'Add',3)
    contents = cellstr(get(handles.model,'String'));
    model = contents(get(handles.model,'Value'));
    
    tracer_props = get_properties2(radiotracer);
    
    model_props = tracer_props;
    if strncmp(model,'One',3)
        model_props = tracer_props.OneTC.k;
    elseif strncmp(model,'Two',3)
        model_props = tracer_props.TwoTC.k;
    end
    
    contents = cellstr(get(handles.region,'String'));
    currfield = contents(get(handles.region,'Value'));
    set(handles.k1,'String',num2str(model_props.(currfield{1})(1)));
    set(handles.k2,'String',num2str(model_props.(currfield{1})(2)));
    if strncmp(model,'Two',3)
        set(handles.k3,'String',num2str(model_props.(currfield{1})(3)));
        set(handles.k4,'String',num2str(model_props.(currfield{1})(4)));
    end
end


% --- Executes during object creation, after setting all properties.
function region_CreateFcn(hObject, ~, handles)
% hObject    handle to region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


function set_brain_regions(handles,tracer_props)

contents = cellstr(get(handles.model,'String'));
model = contents(get(handles.model,'Value'));
model_props = tracer_props;
if strncmp(model,'One',3)
    set(handles.k3,'Visible','off');
    set(handles.k4,'Visible','off');
    model_props = tracer_props.OneTC.k;
else
    set(handles.k3,'Visible','on');
    set(handles.k4,'Visible','on');
    model_props = tracer_props.TwoTC.k;
end
fields = fieldnames(model_props);
set(handles.region,'String',fields);
currfield = fields(get(handles.region,'Value'));
set(handles.k1,'String',num2str(model_props.(currfield{1})(1)));
set(handles.k2,'String',num2str(model_props.(currfield{1})(2)));
if strncmp(model,'Two',3)
    set(handles.k3,'String',num2str(model_props.(currfield{1})(3)));
    set(handles.k4,'String',num2str(model_props.(currfield{1})(4)));
end


% --- Executes on button press in save_k_values.
function save_k_values_Callback(hObject, eventdata, handles)
% hObject    handle to save_k_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global region_rates;

contents = cellstr(get(handles.tracer_lst,'String'));
radiotracer = contents(get(handles.tracer_lst,'Value'));
val = get(handles.tracer_lst,'Value');

contents = cellstr(get(handles.model,'String'));
model = contents(get(handles.model,'Value'));

contents = cellstr(get(handles.region,'String'));
region = contents(get(handles.region,'Value'));

if strncmp(model,'One',3)
    region_rates(val).OneTC.k.(region{1})(1) = str2num(get(handles.k1,'String'));
    region_rates(val).OneTC.k.(region{1})(2) = str2num(get(handles.k2,'String'));
elseif strncmp(model,'Two',3)
    region_rates(val).TwoTC.k.(region{1})(1) = str2num(get(handles.k1,'String'));
    region_rates(val).TwoTC.k.(region{1})(2) = str2num(get(handles.k2,'String'));
    region_rates(val).TwoTC.k.(region{1})(3) = str2num(get(handles.k3,'String'));
    region_rates(val).TwoTC.k.(region{1})(4) = str2num(get(handles.k4,'String'));
end

assignin('base','region_rates',region_rates);


% --- Executes on button press in edit_regions.
function edit_regions_Callback(hObject, eventdata, handles)
% hObject    handle to edit_regions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
