% show_boxes.m
%
% Author: Tom Morin
% Date: June, 2015
%
% Purpose: Show/hide boxes in the Challenge panel of the GUI depending on
% user actions
%
function show_boxes(handles)
% Determine the number of challenges selected
m = str2num(get(handles.num_challenges,'String'));

contents = cellstr(get(handles.competition,'String'));
type = contents{get(handles.competition,'Value')};

% Determine which model is being used
contents = cellstr(get(handles.model,'String'));
model = contents{get(handles.model,'Value')};
irreversible = 0;
if strcmp(model,'2-Tissue Irreversible')
    irreversible = 1;
end

% Adjust visibility based on number of challenges
if m==0
    set(handles.c1,'Visible','off');
    set(handles.challenge_time_text,'Visible','off');
    set(handles.k3_1,'Visible','off');
    set(handles.k4_1,'Visible','off');
    set(handles.k_1_vals_text,'Visible','off');
    set(handles.k_2_vals_text,'Visible','off');
    set(handles.k_3_vals_text,'Visible','off');
    set(handles.k_4_vals_text,'Visible','off');
elseif m==1
    set(handles.c1,'Visible','on');
    set(handles.c2,'Visible','off');
    set(handles.challenge_time_text,'Visible','on');
    set(handles.k3_1,'Visible','on','String','1000');
    set(handles.k3_2,'Visible','off','String','1000');
    set(handles.amplitude_text,'Visible','on');
    if strcmp(type,'Alter Rate Constants')
        set(handles.amplitude_text,'Visible','off');
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_1,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_1,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_1,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_1,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_2,'Visible','off');
        set(handles.k4_2,'Visible','off');
        set(handles.k_3_vals_text,'Visible','on');
        set(handles.k_4_vals_text,'Visible','on');
        if irreversible
            set(handles.k4_1,'Visible','off');
            set(handles.k_4_vals_text,'Visible','on');
        end
    end
elseif m==2
    set(handles.c2,'Visible','on');
    set(handles.c3,'Visible','off');
    set(handles.k3_2,'Visible','on','String','1000');
    set(handles.k3_3,'Visible','off','String','1000');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_2,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_2,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_2,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_2,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_3,'Visible','off');
        set(handles.k4_3,'Visible','off');
        if irreversible
            set(handles.k4_2,'Visible','off');
        end
    end
elseif m==3
    set(handles.c3,'Visible','on');
    set(handles.c4,'Visible','off');
    set(handles.k3_3,'Visible','on','String','1000');
    set(handles.k3_4,'Visible','off','String','1000');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_3,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_3,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_3,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_3,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_4,'Visible','off');
        set(handles.k4_4,'Visible','off');
        if irreversible
            set(handles.k4_3,'Visible','off');
        end
    end
elseif m==4
    set(handles.c4,'Visible','on');
    set(handles.c5,'Visible','off');
    set(handles.k3_4,'Visible','on','String','1000');
    set(handles.k3_5,'Visible','off','String','1000');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_4,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_4,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_4,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_4,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_5,'Visible','off');
        set(handles.k4_5,'Visible','off');
        if irreversible
            set(handles.k4_4,'Visible','off');
        end
    end
elseif m==5
    set(handles.c5,'Visible','on');
    set(handles.c6,'Visible','off');
    set(handles.k3_5,'Visible','on','String','1000');
    set(handles.k3_6,'Visible','off','String','1000');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_5,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_5,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_5,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_5,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_6,'Visible','off');
        set(handles.k4_6,'Visible','off');
        if irreversible
            set(handles.k4_5,'Visible','off');
        end
    end
elseif m==6
    set(handles.k3_6,'Visible','on','String','1000');
    set(handles.k3_7,'Visible','off','String','1000');
    set(handles.c6,'Visible','on');
    set(handles.c7,'Visible','off');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_6,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_6,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_6,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_6,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_7,'Visible','off');
        set(handles.k4_7,'Visible','off');
        if irreversible
            set(handles.k4_6,'Visible','off');
        end
    end
elseif m==7
    set(handles.k3_7,'Visible','on','String','1000');
    set(handles.k3_8,'Visible','off','String','1000');
    set(handles.c7,'Visible','on');
    set(handles.c8,'Visible','off');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_7,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_7,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_7,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_7,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_8,'Visible','off');
        set(handles.k4_8,'Visible','off');
        if irreversible
            set(handles.k4_7,'Visible','off');
        end
    end
elseif m==8
    set(handles.k3_8,'Visible','on','String','1000');
    set(handles.k3_9,'Visible','off','String','1000');
    set(handles.c8,'Visible','on');
    set(handles.c9,'Visible','off');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_8,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_8,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_8,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_8,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_9,'Visible','off');
        set(handles.k4_9,'Visible','off');
        if irreversible
            set(handles.k4_8,'Visible','off');
        end
    end
elseif m==9
    set(handles.k3_9,'Visible','on','String','1000');
    set(handles.k3_10,'Visible','off','String','1000');
    set(handles.c9,'Visible','on');
    set(handles.c10,'Visible','off');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_9,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_9,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_9,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_9,'Visible','on','String',get(handles.k4,'String'));
        end
        set(handles.k3_10,'Visible','off');
        set(handles.k4_10,'Visible','off');
        if irreversible
            set(handles.k4_9,'Visible','off');
        end
    end
elseif m==10
    set(handles.k3_10,'Visible','on','String','1000');
    set(handles.c10,'Visible','on');
    set(handles.c11,'Visible','off');
    if strcmp(type,'Alter Rate Constants')
        if strncmp(model,'1-Tissue',8)
            set(handles.k3_10,'Visible','on','String',get(handles.k1,'String'));
            set(handles.k4_10,'Visible','on','String',get(handles.k2,'String'));
        elseif strncmp(model,'2-Tissue',8)
            set(handles.k3_10,'Visible','on','String',get(handles.k3,'String'));
            set(handles.k4_10,'Visible','on','String',get(handles.k4,'String'));
        end
    end
    if irreversible
            set(handles.k4_10,'Visible','off');
    end
end

end

