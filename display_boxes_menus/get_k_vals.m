%% Get k-values for different brain regions/compartment models/radiotracers
function k = get_k_vals(k_vals,region)
if strcmp(region, 'Select a Brain Region')
    k = NaN;
    warndlg('Please select a brain region.');
elseif strcmp(region, 'General')
    k = k_vals.general;
elseif strcmp(region, 'Frontal Lobe')
    k = k_vals.frontal;
elseif strcmp(region, 'Thalamus')
    k = k_vals.thalamus;
elseif strcmp(region, 'Striatum')
    k = k_vals.striatum;
elseif strcmp(region, 'Anterior Cortex')
    k = k_vals.ant_cx;
elseif strcmp(region, 'Posterior Cortex')
    k = k_vals.post_cx;
elseif strcmp(region, 'Hippocampus')
    k = k_vals.hippocampus;
elseif strcmp(region, 'Medulla')
    k = k_vals.medulla;
elseif strcmp(region, 'Spinal Cord')
    k = k_vals.spinal_cord;
end
end

