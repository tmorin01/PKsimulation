% NO LONGER USED AS A PART OF PK SIM (7/1/15)
% 
% Author: Tom Morin
% Date: June 2015
%
function varargout = time_units_gui(varargin)
% UNITS MATLAB code for units.fig
%      UNITS, by itself, creates a new UNITS or raises the existing
%      singleton*.
%
%      H = UNITS returns the handle to a new UNITS or the handle to
%      the existing singleton*.
%
%      UNITS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNITS.M with the given input arguments.
%
%      UNITS('Property','Value',...) creates a new UNITS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before time_units_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to time_units_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help units

% Last Modified by GUIDE v2.5 25-Jun-2015 10:53:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @time_units_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @time_units_gui_OutputFcn, ...
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


% --- Executes just before units is made visible.
function time_units_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to units (see VARARGIN)

% Choose default command line output for units
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Change Placement on Screen
movegui(gcf,[686 380]);

set(handles.units,'String','Seconds (s)|Minutes (m)|Hours (h)');

% UIWAIT makes units wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = time_units_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in units.
function units_Callback(hObject, eventdata, handles)
% hObject    handle to units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns units contents as cell array
%        contents{get(hObject,'Value')} returns selected item from units

global units;
contents = cellstr(get(handles.units,'String'));
units = contents{get(handles.units,'Value')};
% assignin('base','units',units);


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


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);
