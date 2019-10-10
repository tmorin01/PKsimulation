% SRTM_wizard_gui.m
% Author: Tom Morin
% Date: August, 2015
%
% Purpose: This is the GUI code file for the Simplified Reference Tissue
% Model (SRTM) Wizard.  The wizard allows users to choose an input method,
% create real or simulated TAC curves for a Reference Region and an R.O.I.,
% and then combine these two curves to calculate dynamic binding potential.

function varargout = SRTM_wizard_gui(varargin)
% SRTM_WIZARD_GUI MATLAB code for SRTM_wizard_gui.fig
%      SRTM_WIZARD_GUI, by itself, creates a new SRTM_WIZARD_GUI or raises the existing
%      singleton*.
%
%      H = SRTM_WIZARD_GUI returns the handle to a new SRTM_WIZARD_GUI or the handle to
%      the existing singleton*.
%
%      SRTM_WIZARD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRTM_WIZARD_GUI.M with the given input arguments.
%
%      SRTM_WIZARD_GUI('Property','Value',...) creates a new SRTM_WIZARD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SRTM_wizard_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SRTM_wizard_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SRTM_wizard_gui

% Last Modified by GUIDE v2.5 31-Dec-2015 11:15:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SRTM_wizard_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @SRTM_wizard_gui_OutputFcn, ...
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


% --- Executes just before SRTM_wizard_gui is made visible.
function SRTM_wizard_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SRTM_wizard_gui (see VARARGIN)

% Choose default command line output for SRTM_wizard_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Carry Over Active Compound from the main GUI
list = varargin(2);
value = varargin(3);
entries = list{1}{value{1}};
set(handles.active_comp,'String',entries);
set(handles.active_comp,'Value',1);

% Get the selected Radiotracer from the Main GUI
setappdata(handles.radiotracer,'radiotracer',varargin(1));
radiotracer = getappdata(handles.radiotracer,'radiotracer');
set(handles.radiotracer,'String',radiotracer);

% Populate Brain Region Menus
populate_brain_regions(handles, radiotracer);

% Populate k1 - k4 boxes
contents = cellstr(get(handles.roi,'String'));
roi = contents(1);

contents = cellstr(get(handles.roi_model,'String'));
roi_model = contents(1);

tracer_props = get_properties2(radiotracer);
if strncmp(roi_model,'2-Tissue',8)
    k_vals = tracer_props.TwoTC.k;
    k = get_k_vals(k_vals,roi);
    if ~isnan(k(1))
        set(handles.k1,'String',num2str(k(1)));
        set(handles.k2,'String',num2str(k(2)));
        set(handles.k3,'String',num2str(k(3)));
        set(handles.k4,'String',num2str(k(4)));
    else
        set(handles.k1,'String','0');
        set(handles.k2,'String','0');
        set(handles.k3,'String','0');
        set(handles.k4,'String','0');
    end
else
    set(handles.k1,'String','0');
    set(handles.k2,'String','0');
    set(handles.k3,'String','0');
    set(handles.k4,'String','0');
end

% Populate kr1 & kr2 boxes
if ~isnan(tracer_props.kr(1))
    set(handles.kr1,'String',num2str(tracer_props.kr(1)));
    set(handles.kr2,'String',num2str(tracer_props.kr(2)));
else
    set(handles.kr1,'String','0');
    set(handles.kr2,'String','0');
end

% Decide whether to use simulated data or real TAC data for B/I
if strncmp(tracer_props.bolus_curve,'Not',3)
    set(handles.use_sim_tac,'Value',1);
    set(handles.use_sim_tac,'Enable','off');
    set(handles.use_sim_tac,'String','Using Simulated TAC Data');
else
    set(handles.use_sim_tac,'Value',0);
    set(handles.use_sim_tac,'Enable','on');
    set(handles.use_sim_tac,'String','Using Real TAC Data');
end

% UIWAIT makes SRTM_wizard_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SRTM_wizard_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);


% --- Executes on selection change in reference.
function reference_Callback(hObject, eventdata, handles)
% hObject    handle to reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns reference contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reference


% --- Executes during object creation, after setting all properties.
function reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in roi.
function roi_Callback(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi


% --- Executes during object creation, after setting all properties.
function roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
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

radiotracer = get(handles.radiotracer,'String');

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

k_boxes = {'k1_text';'k2_text';'k3_text';'k4_text';'k1';'k2';'k3';'k4'};
if strcmp(input,'Bolus & Infusion')
    set(handles.kbol_text,'Visible','on');
    set(handles.kbol,'Visible','on');
    set(handles.reference_model,'Visible','on');
    set(handles.roi_model,'Visible','off');
    set(handles.reference,'Visible','on');
    for m=1:length(k_boxes)
        set(handles.(k_boxes{m}),'Visible','off');
    end
    set(handles.use_sim_tac,'Visible','on');
    if get(handles.use_sim_tac,'Value') == 0
        set(handles.reference_model,'Visible','off');
        set(handles.kr1_text,'Visible','off');
        set(handles.kr2_text,'Visible','off');
        set(handles.kr1,'Visible','off');
        set(handles.kr2,'Visible','off');
    else
        set(handles.reference_model,'Visible','on');
        set(handles.kr1_text,'Visible','on');
        set(handles.kr2_text,'Visible','on');
        set(handles.kr1,'Visible','on');
        set(handles.kr2,'Visible','on');
    end
else
    set(handles.kbol_text,'Visible','off');
    set(handles.kbol,'Visible','off');
    set(handles.reference_model,'Visible','on');
    set(handles.roi_model,'Visible','on');
    set(handles.reference,'Visible','off');
    for m=1:length(k_boxes)
        set(handles.(k_boxes{m}),'Visible','on');
    end
    set(handles.use_sim_tac,'Visible','off');
end

if strcmp(input,'Custom')
    set(handles.custom_input,'Visible','on');
else
    set(handles.custom_input,'Visible','off');
end

populate_brain_regions(handles,radiotracer);


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



function kbol_Callback(hObject, eventdata, handles)
% hObject    handle to kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kbol as text
%        str2double(get(hObject,'String')) returns contents of kbol as a double


% --- Executes during object creation, after setting all properties.
function kbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in custom_input.
function custom_input_Callback(hObject, eventdata, handles)
% hObject    handle to custom_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pressed_ok;
pressed_ok = false; % Tells if user finished the custom_import process or exited prematurely

% custom_import global variable contains the matrix of custom AIF data
global custom_input;

h = custom_input_gui(); % This gui helps the user prepare a custom AIF
uiwait(h);

% Time-frame is reset to reflect the new custom AIF
set(handles.scan_time,'String',num2str(floor(custom_input(end,1))));
%set(handles.time,'Enable','off');

if pressed_ok
    message = ['Data successfully imported.  Scan Time = ' num2str(floor(custom_input(end,1))) ' minutes'];
    msgbox(message, 'Import Successful');
    %go_Callback(hObject,eventdata,handles);
end


% --- Executes on selection change in reference_model.
function reference_model_Callback(hObject, eventdata, handles)
% hObject    handle to reference_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns reference_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reference_model

radiotracer = get(handles.radiotracer,'String');
contents = cellstr(get(handles.reference_model,'String'));
reference_model = contents(get(handles.reference_model,'Value'));

populate_brain_regions(handles,radiotracer);

if strncmp(reference_model,'1-Tissue',8)
    set(handles.kr1_text,'Visible','on');
    set(handles.kr2_text,'Visible','on');
    set(handles.kr1,'Visible','on');
    set(handles.kr2,'Visible','on');
else
    set(handles.kr1_text,'Visible','off');
    set(handles.kr2_text,'Visible','off');
    set(handles.kr1,'Visible','off');
    set(handles.kr2,'Visible','off');
end


% --- Executes during object creation, after setting all properties.
function reference_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reference_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in roi_model.
function roi_model_Callback(hObject, eventdata, handles)
% hObject    handle to roi_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi_model

radiotracer = get(handles.radiotracer,'String');
contents = cellstr(get(handles.roi_model,'String'));
roi_model = contents(get(handles.roi_model,'Value'));

populate_brain_regions(handles,radiotracer);

contents = cellstr(get(handles.roi,'String'));
roi = contents(get(handles.roi,'Value'));

tracer_props = get_properties2(radiotracer);

if strncmp(roi_model,'1-Tissue',8)
    set(handles.k3_text,'Visible','off');
    set(handles.k4_text,'Visible','off');
    set(handles.k3,'Visible','off');
    set(handles.k4,'Visible','off');
    k = get_k_vals(tracer_props.OneTC.k,roi);
    if ~isnan(k(1))
        set(handles.k1,'String',num2str(k(1)));
        set(handles.k2,'String',num2str(k(2)));
    end
elseif strncmp(roi_model,'2-Tissue',8)
    set(handles.k3_text,'Visible','on');
    set(handles.k4_text,'Visible','on');
    set(handles.k3,'Visible','on');
    set(handles.k4,'Visible','on');

    k = get_k_vals(tracer_props.TwoTC.k,roi);
    if ~isnan(k(1))
        set(handles.k1,'String',num2str(k(1)));
        set(handles.k2,'String',num2str(k(2)));
        set(handles.k3,'String',num2str(k(3)));
        set(handles.k4,'String',num2str(k(4)));
    end
end
if strcmp(roi_model,'2-Tissue Irreversible')
    set(handles.k3_text,'Visible','on');
    set(handles.k4_text,'Visible','off');
    set(handles.k3,'Visible','on');
    set(handles.k4,'Visible','off');    
    set(handles.k4,'String','0');
end


% --- Executes during object creation, after setting all properties.
function roi_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in plot_reference.
function plot_reference_Callback(hObject, eventdata, handles)
% hObject    handle to plot_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

if strcmp(input,'Choose an Input Method')
    warndlg('Select and Input Method. SRTM_wizard_gui', 'No Input Method Selected');
else
    update_plot('reference',handles);
end


% --- Executes on button press in plot_roi.
function plot_roi_Callback(hObject, eventdata, handles)
% hObject    handle to plot_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

if strcmp(input,'Choose an Input Method')
    warndlg('Select and Input Method. SRTM_wizard_gui', 'No Input Method Selected');
else
    update_plot('roi',handles);
end


% Draw the plot based on user's selections
function update_plot(axes, handles)
global reference_tac roi_tac;

% Gather & initialize user selections
radiotracer = get(handles.radiotracer,'String');
time = str2num(get(handles.scan_time,'String'));
kbol = str2num(get(handles.kbol,'String'));
region = '';
region_value = 0;
model = '';

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

if strcmp(axes,'roi')
    contents = cellstr(get(handles.roi_model,'String'));
    model = contents{get(handles.roi_model,'Value')};

    contents = cellstr(get(handles.roi,'String'));
    region = contents{get(handles.roi,'Value')};
    region_value = get(handles.roi,'Value');
    
elseif strcmp(axes,'reference')
    contents = cellstr(get(handles.reference_model,'String'));
    model = contents{get(handles.reference_model,'Value')};
    
    contents = cellstr(get(handles.reference,'String'));
    region = contents{get(handles.reference,'Value')};
    region_value = get(handles.reference,'Value');
end

use_sim = get(handles.use_sim_tac,'Value');

if strncmp(region,'Select',6)
    warndlg('Please select a Brain Region: SRTM_wixard_gui:update_plot','No Brain Region Selected');
    return;
end

% Get Rate Constants
k(1) = str2num(get(handles.k1,'String'));
k(2) = str2num(get(handles.k2,'String'));
k(3) = str2num(get(handles.k3,'String'));
k(4) = str2num(get(handles.k4,'String'));
kr(1) = str2num(get(handles.kr1,'String'));
kr(2) = str2num(get(handles.kr2,'String'));

% Plot based on Input Method
tac = 0;
if strcmp(input,'Bolus & Infusion')
    Ca = 0;
elseif strcmp(input,'Bolus')
    t = [0:0.5:time];
    Ca = get_InputFunc(handles,'Bolus',t);
    %tac = get_tissue_curve(model, radiotracer, input, region, region_value, time, kbol, Ca, k, kr, axes, use_sim);
elseif strcmp(input,'Infusion')
    t = [0:0.5:time];
    Ca = get_InputFunc(handles,'Infusion',t);
    %tac = get_tissue_curve(model, radiotracer, input, region, region_value, time, kbol, Ca, k, kr, axes, use_sim);
elseif strcmp(input,'Custom')
    global pressed_ok custom_input;
    if ~pressed_ok
        warndlg('Click "Customize" to load custom input data.','Custom Input Data Not Loaded');
        return;
    else
        Ca = custom_input(:,2)';
        assignin('base','Ca',Ca);
        %tac = get_tissue_curve(model, radiotracer, input, region, region_value, time, kbol, Ca, k, kr, axes, use_sim);
    end
end
tac = get_tissue_curve(model, radiotracer, input, region, region_value, time, kbol, Ca, k, kr, axes, use_sim);

% Plot the acquired tissue curve
if strcmp(axes,'roi')
    noise = str2num(get(handles.noise_ROI,'String'));
    tac(2,:) = noiseModel(tac(1,:),tac(2,:),handles,noise);
    roi_tac = tac;
    plot(handles.roi_axes, roi_tac(1,:), roi_tac(2,:), 'Color', [0.6, 0.0, 0.8], 'Linestyle', '-', 'Linewidth', 2);
    title(handles.roi_axes, ['ROI Tissue Curve - ' region],'FontSize',9,'FontWeight','bold','Interpreter','none');
    xlabel(handles.roi_axes, 'Time (min.)','FontSize',7,'FontName','Arial');
    ylabel(handles.roi_axes, 'Radioactivity (arb. units)','FontSize',7,'FontName','Arial')
    set(handles.roi_axes,'FontSize',6);
elseif strcmp(axes,'reference')
    noise = str2num(get(handles.noise_REF,'String'));
    tac(2,:) = noiseModel(tac(1,:),tac(2,:),handles,noise);
    reference_tac = tac;
    plot(handles.reference_axes, reference_tac(1,:), reference_tac(2,:), 'Color', [0.0, 0.4, 0.84], 'Linestyle', '-.', 'Linewidth', 2);
    title(handles.reference_axes, ['Reference Tissue Curve - ' region],'FontSize',9,'FontWeight','bold','Interpreter','none');
    xlabel(handles.reference_axes, 'Time (min.)','FontSize',7,'FontName','Arial');
    ylabel(handles.reference_axes, 'Radioactivity (arb. units)','FontSize',7,'FontName','Arial')
    set(handles.reference_axes,'FontSize',6);
end
assignin('base','roi_tac_KBOL',roi_tac);


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


% --- Executes on button press in use_sim_tac.
function use_sim_tac_Callback(hObject, eventdata, handles)
% hObject    handle to use_sim_tac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_sim_tac

radiotracer = get(handles.radiotracer, 'String');
checked = get(handles.use_sim_tac,'Value');

contents = cellstr(get(handles.input,'String'));
input = contents(get(handles.input,'Value'));

if checked
    set(handles.use_sim_tac,'String','Using Simulated TAC Data');
    if strcmp(input,'Bolus & Infusion')
        set(handles.reference_model,'Visible','on');
        set(handles.kr1_text,'Visible','on');
        set(handles.kr2_text,'Visible','on');
        set(handles.kr1,'Visible','on');
        set(handles.kr2,'Visible','on');
    end
else
    set(handles.use_sim_tac,'String','Using Real TAC Data');
    if strcmp(input,'Bolus & Infusion')
        set(handles.reference_model,'Visible','off');
        set(handles.kr1_text,'Visible','off');
        set(handles.kr2_text,'Visible','off');
        set(handles.kr1,'Visible','off');
        set(handles.kr2,'Visible','off');
    end
end

populate_brain_regions(handles,radiotracer);



function noise_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to noise_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_ROI as text
%        str2double(get(hObject,'String')) returns contents of noise_ROI as a double


% --- Executes during object creation, after setting all properties.
function noise_ROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noise_REF_Callback(hObject, eventdata, handles)
% hObject    handle to noise_REF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_REF as text
%        str2double(get(hObject,'String')) returns contents of noise_REF as a double


% --- Executes during object creation, after setting all properties.
function noise_REF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_REF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


% --- Executes on selection change in active_comp.
function active_comp_Callback(hObject, eventdata, handles)
% hObject    handle to active_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns active_comp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from active_comp


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
