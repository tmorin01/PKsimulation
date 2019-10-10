% show_tracer_props.m
%
% Author: Tom Morin
% Date: June, 2105
%
% Purpose: Populate k-value boxes with k-values from tracer_struct.m
%
function show_tracer_props(tracer_props,handles,origin)
% Makes Radiotracer's properties visible on the PK Simulation GUI

% "origin" tells this function the GUI callback from which it was called (If
% a new radiotracer was just selected, we want to alter the available brain
% regions, but if a brain region was just selected, we only want to switch
% the k-values)

make_invisible(handles);

% Assign literature reference
if ~isempty([tracer_props.ref])
    set(handles.tracer_literature,'String',[tracer_props.ref],'Visible','on');
end

% Assign name
if ~isempty([tracer_props.name])
    set(handles.tracer_name,'String',[tracer_props.name],'Visible','on');
    set(handles.tracer_text,'Visible','on');
end

% Assign reference tissue
if ~isempty([tracer_props.ref_tissue])
    set(handles.ref_tissue,'String',[tracer_props.ref_tissue],'Visible','on');
    set(handles.ref_tissue_text,'Visible','on');
end

% Assign the correct model
contents = cellstr(get(handles.model,'String'));
model_name = contents{get(handles.model,'Value')};

irreversible = 0;

if strcmp(model_name,'2-Tissue Compartment')
    model = tracer_props.TwoTC;
    irreversible = 0;
elseif strcmp(model_name,'2-Tissue Irreversible')
    model = tracer_props.TwoTC;
    irreversible = 1;
elseif strcmp(model_name,'1-Tissue Compartment')
    model = tracer_props.OneTC;
    irreversible = 0;
elseif strcmp(model_name,'B/I Curve')
    return;
elseif strcmp(model_name,'Bolus/Infusion Optimization')
    return;
elseif strcmp(model_name,'SRTM')
    return;
elseif strcmp(model_name,'Logan Reference')
    return;
end

contents = cellstr(get(handles.radiotracer,'String'));
radiotracer = contents{get(handles.radiotracer,'Value')};
if ~strcmp(radiotracer, 'Select a Radiotracer') && ~strcmp(origin,'region')
    set_available_brain_regions(handles,model);
end

% Determine brain region
region_props = model;
contents = get(handles.region,'String');
assignin('base','contents',contents);
region = contents{get(handles.region, 'Value')};
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
% assignin('base', 'region_props', region_props);
% assignin('base', 'region', region);

% Assign k-values
if ~isnan(region_props)
    set(handles.k1,'Visible','on');
    set(handles.k1_text,'Visible','on');
    set(handles.k1,'String',num2str(region_props(1)));
    
    set(handles.k2,'Visible','on');
    set(handles.k2_text,'Visible','on');
    set(handles.k2,'String',num2str(region_props(2)));
    
    if strncmp(model_name,'1-Tissue Compartment',8)
        set(handles.k3,'String','0');
        set(handles.k4,'String','0');
    elseif strncmp(model_name,'2-Tissue', 8) || strncmp(model_name,'SRTM',4);
        set(handles.k3,'Visible','on');
        set(handles.k3_text,'Visible','on');
        set(handles.k3,'String',num2str(region_props(3)));
        if ~irreversible
            set(handles.k4,'Visible','on');
            set(handles.k4_text,'Visible','on');
            set(handles.k4,'String',num2str(region_props(4)));
        else
            set(handles.k4,'String','0');
        end
    end
end

% Assign kp-values
if ~isnan([tracer_props.kp])
    set(handles.kp1,'Visible','on');
    set(handles.kp1_text,'Visible','on');
    set(handles.kp1,'String',num2str(tracer_props.kp(1)));
    
    set(handles.kp2,'Visible','on');
    set(handles.kp2_text,'Visible','on');
    set(handles.kp2,'String',num2str(tracer_props.kp(2)));
    
    if strncmp(model_name,'1-Tissue Compartment',8)
        set(handles.kp3,'String','0');
        set(handles.kp4,'String','0');
    elseif strncmp(model_name,'2-Tissue', 8) || strncmp(model_name,'SRTM',4);
        set(handles.kp3,'Visible','on');
        set(handles.kp3_text,'Visible','on');
        set(handles.kp3,'String',num2str(tracer_props.kp(3)));
        if ~irreversible
            set(handles.kp4,'Visible','on');
            set(handles.kp4_text,'Visible','on');
            set(handles.kp4,'String',num2str(tracer_props.kp(4)));
        else
            set(handles.kp4,'String','0');
        end
    end
end
    
% Assign kr-values
if ~isnan([tracer_props.kr])
    set(handles.kr1,'Visible','on');
    set(handles.kr1_text,'Visible','on');
    set(handles.kr1,'String',num2str(tracer_props.kr(1)));
    
    set(handles.kr2,'Visible','on');
    set(handles.kr2_text,'Visible','on');
    set(handles.kr2,'String',num2str(tracer_props.kr(2)));
end

% Assign k_da-values
if ~isnan([tracer_props.k_da])
    %set(handles.kend1,'Visible','on');
    %set(handles.kend1_text,'Visible','on');
    set(handles.kend1,'String',num2str(tracer_props.k_da(1)));
    
    %set(handles.kend2,'Visible','on');
    %set(handles.kend2_text,'Visible','on');
    set(handles.kend2,'String',num2str(tracer_props.k_da(2)));
end
end

% Set list of Available brain regions
function set_available_brain_regions(handles,model)
regions = {'Select a Brain Region'};
assignin('base','model',model);
if isfield(model.k,'general')
    regions(end+1) = {'General'};
end
if isfield(model.k,'frontal')
    regions(end+1) = {'Frontal Lobe'};
end
if isfield(model.k,'thalamus')
    regions(end+1) = {'Thalamus'};
end
if isfield(model.k,'striatum')
    regions(end+1) = {'Striatum'};
end
if isfield(model.k, 'ant_cx')
    regions(end+1) = {'Anterior Cortex'};
end
if isfield(model.k, 'post_cx')
    regions(end+1) = {'Posterior Cortex'};
end
if isfield(model.k, 'hippocampus')
    regions(end+1) = {'Hippocampus'};
end
if isfield(model.k, 'medulla')
    regions(end+1) = {'Medulla'};
end
if isfield(model.k, 'spinal_cord')
    regions(end+1) = {'Spinal Cord'};
end

set(handles.region,'String',cellstr(regions));
set(handles.region,'Value',2);
end


% Make all k-boxes invisible
function make_invisible(handles)
    set(handles.k1,'Visible','off');
    set(handles.k2,'Visible','off');
    set(handles.k3,'Visible','off');
    set(handles.k4,'Visible','off');
    set(handles.k1_text,'Visible','off');
    set(handles.k2_text,'Visible','off');
    set(handles.k3_text,'Visible','off');
    set(handles.k4_text,'Visible','off');
    set(handles.kp1,'Visible','off');
    set(handles.kp2,'Visible','off');
    set(handles.kp3,'Visible','off');
    set(handles.kp4,'Visible','off');
    set(handles.kp1_text,'Visible','off');
    set(handles.kp2_text,'Visible','off');
    set(handles.kp3_text,'Visible','off');
    set(handles.kp4_text,'Visible','off');
    set(handles.kr1,'Visible','off');
    set(handles.kr2,'Visible','off');
    set(handles.kr1_text,'Visible','off');
    set(handles.kr2_text,'Visible','off');
    set(handles.kend1,'Visible','off');
    set(handles.kend2,'Visible','off');
    set(handles.kend1_text,'Visible','off');
    set(handles.kend2_text,'Visible','off');
    set(handles.tracer_literature,'Visible','off');
    set(handles.tracer_text,'Visible','off');
    set(handles.tracer_name,'Visible','off');
    set(handles.ref_tissue_text,'Visible','off');
    set(handles.ref_tissue,'Visible','off');
end

