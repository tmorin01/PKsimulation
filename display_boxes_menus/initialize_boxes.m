% initialize_boxes.m
% 
% Author: Tom Morin
% Date: July, 2015
%
% Purpose: Show/hide boxes in the "Challenge" section of the GUI based on
% user actions.
%
function initialize_boxes(handles)
% Use the info from the "Challenge" section of the GUI to decide which
% boxes to show

% Determine the type of challenge (Endogenous Dopamine, etc.)
contents = cellstr(get(handles.competition,'String'));
type = contents{get(handles.competition,'Value')};

% Get model selection
contents = cellstr(get(handles.model,'String'));
model = contents{get(handles.model,'Value')};
irreversible = 0;
if strcmp(model,'2-Tissue Irreversible')
    irreversible = 1;
end

% Make everything invisible if no challenges were selected
if strcmp(type,'None')
    set(handles.num_challenges,'String','0');
    make_all_invisible(handles);
% Make kend visible if Endogenous DA challenge selected
elseif strcmp(type,'Endogenous Dopamine') || strcmp(type, 'Cold FDG')
    make_all_invisible(handles);
    set(handles.num_challenges,'Enable','on','String','1');
    set(handles.c1,'Visible','on');
    set(handles.k3_1,'Visible','on','String','1000');
    set(handles.challenge_time_text,'Visible','on');
    set(handles.kend1,'Visible','on');
    set(handles.kend2,'Visible','on');
    set(handles.kend1_text,'Visible','on');
    set(handles.kend2_text,'Visible','on');
    set(handles.amplitude_text,'Visible','on');
    set(handles.num_challenges,'Enable','on');
    set(handles.plus_challenge,'Enable','on');
    %set(handles.minus_challenge,'Enable','on');
% Make k3 & k4 visible if Articifial Challenging is Selected
elseif strcmp(type, 'Alter Rate Constants')
    make_all_invisible(handles);
    set(handles.num_challenges,'Enable','on','String','1');
    set(handles.c1,'Visible','on');
    set(handles.challenge_time_text,'Visible','on');
    set(handles.num_challenges,'Enable','on');
    set(handles.plus_challenge,'Enable','on');
    set(handles.amplitude_text,'Visible','off');
    %set(handles.minus_challenge,'Enable','on');
    set(handles.k_3_vals_text,'Visible','on');
    set(handles.k_4_vals_text,'Visible','on');
    set(handles.k3_1,'Visible','on');
    set(handles.k4_1,'Visible','on');
    if strcmp(get(handles.k3,'Visible'),'on')
        set(handles.k3_1,'String',get(handles.k3,'String'))
        set(handles.k4_1,'String',get(handles.k4,'String'));
    end
    if irreversible
        set(handles.k4_1,'Visible','off');
        set(handles.k_4_vals_text,'Visible','off');
    end
    if strncmp(model,'1-Tissue', 8)
        set(handles.k_1_vals_text,'Visible','on');
        set(handles.k_2_vals_text,'Visible','on');
        set(handles.k_3_vals_text,'Visible','off');
        set(handles.k_4_vals_text,'Visible','off');
        set(handles.k3_1,'String',get(handles.k1,'String'));
        set(handles.k4_1,'String',get(handles.k2,'String'));
    end
% elseif strcmp(type, 'Cold FDG')
%     make_all_invisible(handles);
%     set(handles.num_challenges,'Enable','on','String','1');
%     set(handles.c1,'Visible','on');
%     set(handles.challenge_time_text,'Visible','on');
%     set(handles.num_challenges,'Enable','on');
%     set(handles.plus_challenge,'Enable','on');
else
    disp('Nope...');
end
end

% Make all the boxes invisible
function make_all_invisible(handles)
set(handles.num_challenges,'Enable','off');
set(handles.plus_challenge,'Enable','off');
set(handles.minus_challenge,'Enable','off');
set(handles.c1,'Visible','off');
set(handles.c2,'Visible','off');
set(handles.c3,'Visible','off');
set(handles.c4,'Visible','off');
set(handles.c5,'Visible','off');
set(handles.c6,'Visible','off');
set(handles.c7,'Visible','off');
set(handles.c8,'Visible','off');
set(handles.c9,'Visible','off');
set(handles.c10,'Visible','off');
set(handles.k3_1,'Visible','off');
set(handles.k3_2,'Visible','off');
set(handles.k3_3,'Visible','off');
set(handles.k3_4,'Visible','off');
set(handles.k3_5,'Visible','off');
set(handles.k3_6,'Visible','off');
set(handles.k3_7,'Visible','off');
set(handles.k3_8,'Visible','off');
set(handles.k3_9,'Visible','off');
set(handles.k3_10,'Visible','off');
set(handles.k4_1,'Visible','off');
set(handles.k4_2,'Visible','off');
set(handles.k4_3,'Visible','off');
set(handles.k4_4,'Visible','off');
set(handles.k4_5,'Visible','off');
set(handles.k4_6,'Visible','off');
set(handles.k4_7,'Visible','off');
set(handles.k4_8,'Visible','off');
set(handles.k4_9,'Visible','off');
set(handles.k4_10,'Visible','off');
set(handles.kend1,'Visible','off');
set(handles.kend2,'Visible','off');
set(handles.kend1_text,'Visible','off');
set(handles.kend2_text,'Visible','off');
set(handles.k_1_vals_text,'Visible','off');
set(handles.k_2_vals_text,'Visible','off');
set(handles.k_3_vals_text,'Visible','off');
set(handles.k_4_vals_text,'Visible','off');
set(handles.challenge_time_text,'Visible','off');
set(handles.amplitude_text,'Visible','off');
end
