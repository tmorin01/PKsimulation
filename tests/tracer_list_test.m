tracers = tracer_struct();
for m=1:length(tracers)
    if m==1
        tracer_list = tracers(m).name;
    else
        tracer_list = [tracer_list '|' tracers(m).name];
    end
end