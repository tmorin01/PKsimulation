% get_properties2.m
% 
% Author: Tom Morin
% Date: July, 2015
% Purpose: Retrieve a struct called "tracer_props" with all of the
% properties of the specified "radiotracer."
% If ARG = 'all', this will return a struct containing information for all
% available radiotracers
%
function tracer_props = get_properties2(radiotracer)
% tracer_lst = tracer_struct();
global global_tracers;

if ispc
    tracer_lst = global_tracers(3:end);
else
    tracer_lst = global_tracers;
end

% return a struct containing information for all radiotracers
if strcmp(radiotracer,'all')
    tracer_props = tracer_lst;
    return;
% return a struct containing information for a signle radiotracer
else
    found = 0;
    for m=1:length(tracer_lst)
        if strcmp(tracer_lst(m).name,radiotracer)
            tracer_props = tracer_lst(m);
            found = 1;
        end
    end
    
    % I no readiotracer has been selected
    if strcmp(radiotracer,'Select a Radiotracer')
        tracer_props.name            = '';
        tracer_props.ref             = '';
        tracer_props.ref_tissue      = '';
        tracer_props.compounds       = {};
        tracer_props.available_areas = {'General'};
        tracer_props.TwoTC.k.general = NaN;
        tracer_props.OneTC.k.general = NaN;
        tracer_props.kp              = NaN;
        tracer_props.kr              = NaN;
        tracer_props.k_da            = NaN;
        tracer_props.bolus_curve     = 'Not Available';
    elseif ~found && ~strcmp(radiotracer,'Select a Radiotracer')
        warndlg('Radiotracer not found. (Error in get_properties2:13)','Invalid Radiotracer')
    end
end