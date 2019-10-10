% Author: Tom Morin
% Date: July, 2015
% Purpose: Default Time Activity Curve (TAC) data files are stored in the
% "Default_TACs" folder.  This function retrieves the appropriate file for
% the selected radiotracer and loads the data into a matrix called
% "tissue_tac"

% If it exists, get the default TAC for the specified radiotracer.  The
% default TAC is a text file giving time & activity data for different
% brain regions
function tac = get_default_TAC(handles,radiotracer,region)
global BI_Options global_tracers;

if strcmp(radiotracer,'Select a Radiotracer')
    tac= 0;
    return;
end

% Get radiotracer information
%tracers = tracer_struct();
tracers = global_tracers;

for m=1:length(tracers)
    if strcmp(tracers(m).name,radiotracer)
        directory = tracers(m).bolus_curve;
        if strcmp(directory,'Not Available')
            BI_Options.used_default = 0;
            %disp('No Default TAC Available');
            % Adjust GUI appearance 
            set(handles.brain_region,'String','N/A')
            set(handles.file,'Enable','on');
            set(handles.get_file,'Enable','on');
            tac = 0;
        else
            BI_Options.used_default = 1;
            % Adjust GUI appearance
            set(handles.file,'String',directory);
            % Get TAC data
            input = importdata(directory);
            regions = input.textdata{1};
            regions = regexprep(regions,'\t','|');
            set(handles.brain_region,'String',regions);      
            tac(1,:) = input.data(:,1)'./60;
            tac(2,:) = input.data(:,region)';
        end
    end
end

