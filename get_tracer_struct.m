% get_tracer_struct.m
%
% Author: Tom Morin
% Date: July, 2015
% Purpose: Read in all radiotracer text files & create a tracer_struct
%
function R = get_tracer_struct()

i=1;
if ispc
    files = cellstr(ls('Radiotracers'));
    i=3;
    iterations = length(files);
else
    temp = ls('Radiotracers');
    files = strsplit(temp)';
    files = sort(files);
    for m=1:length(files)-1
        files{m} = files{m+1};
    end
    files{end} = {};
    i=1;
    iterations = length(files)-1;
end

for m=i:iterations
    fID = fopen([files{m}],'r');
    tline = 0;
    while (tline ~= (-1))
        % Tracer name
        R(m).name = fgets(fID);
        R(m).name = strtrim(R(m).name);
        
        % Literature Reference
        R(m).ref = fgets(fID);
        R(m).ref = strtrim(R(m).ref);
        
        % Reference Tissue
        R(m).ref_tissue = fgets(fID);
        R(m).ref_tissue = strtrim(R(m).ref_tissue);
        
        % Radioactive Isotopes
        i = 1;
        temp = [];
        while ~strncmp(temp,'*',1)
            temp = fgets(fID);
            temp = strtrim(temp);
            if ~strncmp(temp,'*',1)
                R(m).compounds{i} = temp;
            end
            i=i+1;
        end
        
        % Available brain areas
        i = 1;
        temp = [];
        while ~strncmp(temp,'*',1)
            temp = fgets(fID);
            temp = strtrim(temp);
            if ~strncmp(temp,'*',1)
                R(m).available_areas{i} = temp;
            end
            i=i+1;
        end
        
        % K-Values for 1-TC & 2-TC
        temp = fgets(fID);
        if strncmp(temp, '*****1', 6)
            while true
                field = fgets(fID);
                field = strtrim(field);
                if strncmp(field, '*****2', 6)
                    break;
                end
                k = fscanf(fID,'%g\t%g\n');
                R(m).OneTC.k.(field) = k';
            end
            while true
                field = fgets(fID);
                field = strtrim(field);
                if strncmp(field, '*****O', 6)
                    break;
                end
                k = fscanf(fID,'%g\t%g\t%g\t%g\n');
                R(m).TwoTC.k.(field) = k';
            end
        end
        
        % KP
        field = fgets(fID);
        kp = fscanf(fID,'%g');
        if isnan(kp)
            R(m).kp = kp;
        else
            R(m).kp = cat(2,kp,fscanf(fID,'%g\t%g\t%g\n'));
        end
        
        %KR
        field = fgets(fID);
        kr = fscanf(fID,'%g');
        if isnan(kr)
            R(m).kr = kr;
        else
            R(m).kr = cat(2,kr,fscanf(fID,'%g\t%g\t%g\n'));
        end
        
        %K_DA
        field = fgets(fID);
        k_da = fscanf(fID,'%g');
        if isnan(k_da)
            R(m).k_da = k_da;
        else
            R(m).k_da = cat(2,k_da,fscanf(fID,'%g\t%g\t%g\n'));
        end
        
        % Path to TAC data file
        R(m).bolus_curve = fgets(fID);
        tline = fgets(fID);
    end
    fclose('all');
end
end