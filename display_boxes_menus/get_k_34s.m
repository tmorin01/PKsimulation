% get_k_34s.m
%
% Author: Tom Morin
% Date: June 2015
%
% Purpose: Populate a matrix called k_34s with user-specified k3 and k4
% values for an artificial challenge

function k_34s = get_k_34s(handles)
% Get the k_3 and k_4 values for each indicated challenge time
% For 'Artificial (Use k3 & k4)'

% k_34s --> row1 = the altered k3 values
%       --> row2 = the altered k4 values

% Get user-selected k_3 values
if ~isempty(get(handles.k3_1,'String'))
    k_34s(1,1) = str2num(get(handles.k3_1,'String'));
end
if ~isempty(get(handles.k3_2,'String'))
    k_34s(1,2) = str2num(get(handles.k3_2,'String'));
end
if ~isempty(get(handles.k3_3,'String'))
    k_34s(1,3) = str2num(get(handles.k3_3,'String'));
end
if ~isempty(get(handles.k3_4,'String'))
    k_34s(1,4) = str2num(get(handles.k3_4,'String'));
end
if ~isempty(get(handles.k3_5,'String'))
    k_34s(1,5) = str2num(get(handles.k3_5,'String'));
end
if ~isempty(get(handles.k3_6,'String'))
    k_34s(1,6) = str2num(get(handles.k3_6,'String'));
end
if ~isempty(get(handles.k3_7,'String'))
    k_34s(1,7) = str2num(get(handles.k3_7,'String'));
end
if ~isempty(get(handles.k3_8,'String'))
    k_34s(1,8) = str2num(get(handles.k3_8,'String'));
end
if ~isempty(get(handles.k3_9,'String'))
    k_34s(1,9) = str2num(get(handles.k3_9,'String'));
end
if ~isempty(get(handles.k3_10,'String'))
    k_34s(1,10) = str2num(get(handles.k3_10,'String'));
end

% Get user-selected k_4 values
if ~isempty(get(handles.k4_1,'String'))
    k_34s(2,1) = str2num(get(handles.k4_1,'String'));
end
if ~isempty(get(handles.k4_2,'String'))
    k_34s(2,2) = str2num(get(handles.k4_2,'String'));
end
if ~isempty(get(handles.k4_3,'String'))
    k_34s(2,3) = str2num(get(handles.k4_3,'String'));
end
if ~isempty(get(handles.k4_4,'String'))
    k_34s(2,4) = str2num(get(handles.k4_4,'String'));
end
if ~isempty(get(handles.k4_5,'String'))
    k_34s(2,5) = str2num(get(handles.k4_5,'String'));
end
if ~isempty(get(handles.k4_6,'String'))
    k_34s(2,6) = str2num(get(handles.k4_6,'String'));
end
if ~isempty(get(handles.k4_7,'String'))
    k_34s(2,7) = str2num(get(handles.k4_7,'String'));
end
if ~isempty(get(handles.k4_8,'String'))
    k_34s(2,8) = str2num(get(handles.k4_8,'String'));
end
if ~isempty(get(handles.k4_9,'String'))
    k_34s(2,9) = str2num(get(handles.k4_9,'String'));
end
if ~isempty(get(handles.k4_10,'String'))
    k_34s(2,10) = str2num(get(handles.k4_10,'String'));
end

end