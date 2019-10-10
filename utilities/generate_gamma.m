% Author: Tom Morin
% Date: August 2015
% Purpose: Generate an arbitrary gamma curve at each challenge time
%           - Height of generated curve depends on the specified
%           "amplitude".  Width of curve depends on "toa" (set in
%           SRTM_sim.m")

function gamma_curve = generate_gamma(time, chal_times, tao, amplitude)

gamma_curve = zeros(1,length(time));

if ~isnan(chal_times)
    for m=1:length(chal_times)
        first = chal_times(m) * 2;
        last = time(end)*2 + 1;
        t = ((last - first))/2;
        pulse = gamma_var(amplitude(m)/100,tao,t);
        pulse = pulse';
        gamma_curve(first:last) = gamma_curve(first:last) + pulse(2,:);
    end
else
    return
end

