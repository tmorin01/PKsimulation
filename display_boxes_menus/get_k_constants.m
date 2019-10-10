% get_k_constants.m
% 
% Author: Tom Morin
% Date: June 2015
%
% Purpose: Use the k-values listed in the textboxes to run the simulation
% (This is in case a user manually alters individual k-values).
%
function [k, kp, kr, k_da] = get_k_constants(handles)
    %Get k constants for compartmental modelling
    
    % For a 2-Tissue Compartmental Model
%     contents = cellstr(get(handles.model,'String'));
%     model = contents{get(handles.model,'Value')};
%     if strcmp(model,'2-Tissue Compartment') || strcmp(model,
        
        % Get k-values from GUI
        if strcmp(get(handles.k1,'Visible'),'on')
            k(1) = str2num(get(handles.k1,'String'));
            k(2) = str2num(get(handles.k2,'String'));
            k(3) = str2num(get(handles.k3,'String'));
            k(4) = str2num(get(handles.k4,'String'));
        else
            k = NaN;
        end
        
        % Get kp-values from GUI
        if strcmp(get(handles.kp1,'Visible'),'on')
            kp(1) = str2num(get(handles.kp1,'String'));
            kp(2) = str2num(get(handles.kp2,'String'));
            kp(3) = str2num(get(handles.kp3,'String'));
            kp(4) = str2num(get(handles.kp4,'String'));
        else
            kp = NaN;
        end
        
        % Get kr-values from GUI
        if strcmp(get(handles.kr1,'Visible'),'on')
            kr(1) = str2num(get(handles.kr1,'String'));
            kr(2) = str2num(get(handles.kr2,'String'));
        else
            kr = NaN;
        end
        
        % Get k-endogenous values from GUI
        if strcmp(get(handles.kend1,'Visible'),'on')
            k_da(1) = str2num(get(handles.kend1,'String'));
            k_da(2) = str2num(get(handles.kend2,'String'));
        else
            k_da = NaN;
        end
    end
% end