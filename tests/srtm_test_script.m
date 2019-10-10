td = time';
ref = cerebellum(2,:)';
roi = putamen(2,:)';
assignin('base','roi',roi);
x0 = zeros(179,1);
p0 = [1 1 1];
psolve = fminsearch(@(p) SRTM_objective(td, ref, roi, p, x0), p0);