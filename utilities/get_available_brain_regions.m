% Set list of available brain regions from Tracer Struct
function regions = get_available_brain_regions(model)
regions = {};
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
end

