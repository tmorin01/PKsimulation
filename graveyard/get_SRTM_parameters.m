% Author: Tom Morin
% Date: July, 2015
% Purpose: This function determines which reference region was selected and
% gets the time activity curve (TAC) for that region.

function get_SRTM_parameters(handles)

global TAC;

contents = cellstr(get(handles.radiotracer,'String'));
radiotracer = contents{get(handles.radiotracer,'Value')};

contents = cellstr(get(handles.input,'String'));
input = contents{get(handles.input,'Value')};

contents = cellstr(get(handles.region,'String'));
region = contents{get(handles.region,'Value')};

% If a Reference Region is selected, get the TAC data for the region
ref_region = 1;
ROI = 1;

if ~strcmp(input,'Select an Input Function')
    ref_region = get(handles.input,'Value');
end
if ~strcmp(region,'Select a Brain Region')
    ROI = get(handles.region,'Value');
end

TAC = get_default_TAC(handles,radiotracer,ref_region,ROI,'SRTM');
set(handles.time,'String',num2str(floor(TAC.reference(1,end)))); % Set the scan duration to the final time in the TAC file
%assignin('base','REF_TAC',REF_TAC);

end