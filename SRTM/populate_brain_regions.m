% populate_brain_regions.m
%
% Author: Tom Morin
% Date: July, 2015
% Purpose: Determine which brain regions are available based on user
% selections

function populate_brain_regions(handles, radiotracer)

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

tracer_props = get_properties2(radiotracer);
%assignin('base','tracer_props',tracer_props);

contents = cellstr(get(handles.reference_model,'String'));
reference_model = contents{get(handles.reference_model,'Value')};
contents = cellstr(get(handles.roi_model,'String'));
roi_model = contents{get(handles.roi_model,'Value')};

reference_regions = tracer_props.available_areas;
roi_regions = tracer_props.available_areas;

if strcmp(input,'Bolus & Infusion')
    checked = get(handles.use_sim_tac,'Value');
    if checked
        if strcmp(reference_model,'Plasma')
            disp('Setting as Plasma');
            reference_regions = 'Plasma';
        elseif strncmp(reference_model,'1-Tissue',8)
            reference_regions = tracer_props.ref_tissue;
        end
        roi_regions = get_available_brain_regions(tracer_props.TwoTC);     
    else
        reference_regions = get_BI_regions(handles,tracer_props);
        roi_regions = get_BI_regions(handles,tracer_props);
    end
else
    if strncmp(reference_model,'1-Tissue',8)
        reference_regions = get_available_brain_regions(tracer_props.OneTC);
    end
    if strncmp(roi_model,'1-Tissue',8)
        roi_regions = get_available_brain_regions(tracer_props.OneTC);
    end
    if strncmp(reference_model,'2-Tissue',8)
        reference_regions = get_available_brain_regions(tracer_props.TwoTC);
    end
    if strncmp(roi_model,'2-Tissue',8)
        roi_regions = get_available_brain_regions(tracer_props.TwoTC);
    end    
end

set(handles.reference,'String',reference_regions);
set(handles.roi,'String',roi_regions);
    
end


% Set list of available brain regions from default BI file
function regions = get_BI_regions(handles,tracer_props)

if strcmp(tracer_props.bolus_curve,'Not Available')
    regions = tracer_props.available_areas;
else
    input = importdata(tracer_props.bolus_curve);
    regions = input.textdata{1};
    regions = regexprep(regions,'\t','|');
    time = floor(input.data(end,1)./60);
    set(handles.scan_time,'String',num2str(time));
end
end


% % Set list of available brain regions from Tracer Struct
% function regions = get_available_brain_regions(model)
% regions = {};
% if isfield(model.k,'general')
%     regions(end+1) = {'General'};
% end
% if isfield(model.k,'frontal')
%     regions(end+1) = {'Frontal Lobe'};
% end
% if isfield(model.k,'thalamus')
%     regions(end+1) = {'Thalamus'};
% end
% if isfield(model.k,'striatum')
%     regions(end+1) = {'Striatum'};
% end
% if isfield(model.k, 'ant_cx')
%     regions(end+1) = {'Anterior Cortex'};
% end
% if isfield(model.k, 'post_cx')
%     regions(end+1) = {'Posterior Cortex'};
% end
% if isfield(model.k, 'hippocampus')
%     regions(end+1) = {'Hippocampus'};
% end
% if isfield(model.k, 'medulla')
%     regions(end+1) = {'Medulla'};
% end
% if isfield(model.k, 'spinal_cord')
%     regions(end+1) = {'Spinal Cord'};
% end
% end