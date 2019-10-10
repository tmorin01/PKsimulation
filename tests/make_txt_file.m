function make_txt_file( r )

% Open the file
filename = fullfile('Radiotracers',[r.name '.txt']);
fID = fopen(filename,'w');

% Print the Name, lit reference, & reference tissue
fprintf(fID, '%s\n', r.name);
assignin('base','compounds',r.compounds)
fprintf(fID, '%s\n%s\n', r.ref, r.ref_tissue);

% Print the radioactive isotopes for this tracer (C-11 & F-18)
for m=1:length(r.compounds)
    fprintf(fID,'%s\n',[r.compounds{m}]);
end
fprintf(fID,'*\n');

% Print the available brain areas for this tracer
for m=1:length(r.available_areas)
    fprintf(fID,'%s\n',[r.available_areas{m}]);
end
fprintf(fID,'*\n');

fprintf(fID,'*****1-Tissue Compartment*****\n');

% Print the k-values for 1-TC Model
regions = fieldnames(r.OneTC.k);
assignin('base','regions',regions);
for m=1:length(regions)
    fprintf(fID,'%s\n',regions{m});
    fprintf(fID,'%g\t%g\n',r.OneTC.k.(regions{m}));
end

fprintf(fID,'*****2-Tissue Compartment*****\n');

% Print the k-values for 2-TC Model
regions = fieldnames(r.TwoTC.k);
assignin('base','regions',regions);
for m=1:length(regions)
    fprintf(fID,'%s\n',regions{m});
    fprintf(fID,'%g\t%g\t%g\t%g\n',r.TwoTC.k.(regions{m}));
end

fprintf(fID,'*****Other K-Values*****\n');

% Print the kp values
fprintf(fID, 'kp\n');
if isnan(r.kp)
    fprintf(fID,'%g\n',r.kp);
else
    fprintf(fID,'%g\t%g\t%g\t%g\n',r.kp);
end

% Print the kr values
fprintf(fID, 'kr\n');
if isnan(r.kr)
    fprintf(fID,'%g\n',r.kr);
else
    fprintf(fID,'%g\t%g\n',r.kr);
end

% Print the k_da values
fprintf(fID, 'k_da\n');
if isnan(r.k_da)
    fprintf(fID,'%g\n',r.k_da);
else
    fprintf(fID,'%g\t%g\n',r.k_da);
end

% Print the directory of the TAC file or print 'Not Available'
fprintf(fID,'%s',r.bolus_curve);

fclose(fID);

end

