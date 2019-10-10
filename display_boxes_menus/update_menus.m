% update_menus.m
% Author: Tom Morin
% Date: July, 2015
% Purpose: Update all main GUI menus to reflect changes to any other GUI
% menu

function update_menus(origin, handles)
%This function executes whenever a menu option is selected on the main GUI.
% It updates all the other menus & boxes accordingly.

contents = cellstr(get(handles.model,'String'));
model = contents{get(handles.model,'Value')};

contents = cellstr(get(handles.radiotracer, 'String'));
radiotracer = contents{get(handles.radiotracer, 'Value')};

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if strcmp(origin, 'model') 
    
    % Show k-values & determine available brain regions
    if ~strcmp(radiotracer,'Select a Radiotracer')
        tracer_props = get_properties2(radiotracer);
        show_tracer_props(tracer_props,handles,'tracer');
    end
    
    % Set list of available Challenges for this Radiotracer & this input
    set_available_challenges(handles);
    
    % If SRTM, display Reference Region Selection.  Else, Input Function
    % Selection
    if strcmp(model, 'SRTM')
        set(handles.SRTM_wizard,'Visible','on');
        set(handles.logan_wizard,'Visible','off');
        set(handles.input_function_text,'Visible','off');
        set(handles.input,'Visible','off');
        set(handles.region,'Visible','off');
        set(handles.brain_roi_text,'Visible','off');
        set(handles.set_k_bol,'Visible','off');
        set(handles.import_txt,'Visible','off');
        return;
    elseif strcmp(model, 'Logan Reference')
        set(handles.logan_wizard,'Visible','on');
        set(handles.SRTM_wizard,'Visible','off');
        set(handles.input_function_text,'Visible','off');
        set(handles.input,'Visible','off');
        set(handles.region,'Visible','off');
        set(handles.brain_roi_text,'Visible','off');
        set(handles.set_k_bol,'Visible','off');
        set(handles.import_txt,'Visible','off');
        return;
    else
        set(handles.SRTM_wizard,'Visible','off');
        set(handles.logan_wizard,'Visible','off');
        set(handles.input_function_text,'Visible','on');
        set(handles.input,'Visible','on');
        set(handles.region,'Visible','on');
        set(handles.brain_roi_text,'Visible','on');
    end
    
    if strncmp(model, 'Bolus/Inf',9)
        set(handles.set_k_bol,'Visible','on');
        set(handles.region,'Visible','off');
        set(handles.brain_roi_text,'Visible','off');
        set(handles.input,'Value',1);
        set(handles.input,'String','Bolus & Infusion');
        set(handles.input,'Enable','off');
        set(handles.import_txt,'Visible','off');
        return;
    else
        set(handles.set_k_bol,'Visible','off');
        set(handles.region,'Visible','on');
        set(handles.brain_roi_text,'Visible','on');
        set(handles.input,'Value',1);
        set(handles.input,'String',cellstr({'Select an Input Function';'Bolus';'Infusion';'Custom'}));
        set(handles.input,'Enable','on');
    end
        
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
elseif strcmp(origin, 'input')

    % For Custom Input Show Customize Button
    if strncmp(input,'Custom',6)
        set(handles.import_txt,'Visible','on');
    else
        set(handles.import_txt,'Visible','off');
        %set(handles.time,'Enable','on','String','200');
    end
    
    % Set list of available Challenges for this Radiotracer & this input
    % set_available_challenges(handles);
    
    % Update K-values
    if ~strncmp(radiotracer, 'Select', 6)
        tracer_props = get_properties2(radiotracer);
        show_tracer_props(tracer_props,handles,'input');
    end
    
    if strcmp(model, 'SRTM')
        get_SRTM_raw_data(handles);
%     else
%         set(handles.get_tac_data,'Visible','off');
    end
    
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
elseif strcmp(origin, 'radiotracer')
    
    if strcmp(radiotracer, 'Advanced')
        h = radiotracer_options_gui();
        uiwait(h);
    else
        tracer_props = get_properties2(radiotracer);
        
        % Set list of available Challenges for this Radiotracer & this input
        set_available_challenges(handles);
        
        % Set list of tracer isotopes (C-11 or F-18)
        comps = tracer_props.compounds;
        set(handles.active_comp,'Value',1);
        set(handles.active_comp,'String',cellstr(comps),'Visible','on');
        
        % Show k-values & determine available brain regions
        show_tracer_props(tracer_props,handles,'tracer');
    end
    

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
elseif strcmp(origin, 'region')
    tracer_props = get_properties2(radiotracer);
    show_tracer_props(tracer_props,handles,'region');
end

end


function set_available_challenges(handles)
% Sets the types of challenges that are available for a specific
% radiotracer & input function
contents = cellstr(get(handles.radiotracer, 'String'));
radiotracer = contents{get(handles.radiotracer, 'Value')};

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

contents = cellstr(get(handles.model,'String'));
model = contents{get(handles.model,'Value')};

tracer_props = get_properties2(radiotracer);

if strcmp(input,'Bolus & Infusion')
    if ~isnan(tracer_props.k_da)
        available_chals = 'None|Endogenous Dopamine';
    elseif strcmp(radiotracer,'FDG')
        available_chals = 'None|Cold FDG';       
    else
        available_chals = 'None';
    end
elseif strncmp(model,'SRTM',4) || strncmp(model,'Bolus',5)
    if ~isnan(tracer_props.k_da)
        available_chals = 'None|Endogenous Dopamine';
    elseif strcmp(radiotracer,'FDG')
        available_chals = 'None|Cold FDG';  
    else
        available_chals = 'None';
    end
else
    available_chals = 'None|Alter Rate Constants';
    if ~isnan(tracer_props.k_da)
        available_chals = [available_chals '|Endogenous Dopamine'];
    elseif strcmp(radiotracer,'FDG')
        available_chals = 'None|Cold FDG'; 
    end
end
set(handles.competition,'Value',1);
set(handles.competition,'String',available_chals);
initialize_boxes(handles);
end

