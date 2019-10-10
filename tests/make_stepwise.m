% make_stepwise()
%
%  Author: Tom Morin
%    Date: September, 2015
%
% Purpose: Make everything before time = pivot stepwise (as if small pulses
% were being given instead of a smooth continuous infusion)
%
% INPUT:
%       start_steps -- time (in seconds) at which stepping starts
%       pivot -------- time (in seconds) to switch from stepwise to continous
%       interval ----- time (in seconds) of each "step"
%       AIF ---------- 2D array of times & corresponding Ca or Cp measures
% OUTPUT:
%       new_AIF ------ new AIF with stepwise piece instead of smooth piece


function new_AIF = make_stepwise(start_steps, pivot, interval, AIF)

down_slope = [0,-0.00132018888592711,-0.00604160068636084,-0.0137595505584907,-0.0241070795648932,-0.0367517744886410,-0.0513928409101920,-0.0677584101065007,-0.0856030617868422,-0.104705546027148,-0.124866689013025,-0.145907468358147,-0.167667244836097,-0.190002138356100,-0.212783536932237,-0.235896728246872,-0.259239644197267,-0.282721709544086,-0.306262786456158,-0.329792207371246,-0.353247889171471,-0.376575522207778,-0.399727828203571,-0.422663881526362,-0.445348488740650,-0.467751621747793,-0.489847900181705,-0.511616119065004,-0.533038818040694,-0.554101888781512,-0.574794217444425];
up_slope = 0.15;
current_step = 0;
new_AIF = AIF;
decreasing = false;
n = 1;
switch_point = 1;

for m=1:length(AIF)
    if m < start_steps
        new_AIF(2,m) = AIF(2,m);
    elseif m < pivot
        if mod(m, interval) == 0
            current_step = AIF(2,m);
            decreasing = ~decreasing;
            n = 1;
            if m ==1
                switch_point = 1;
            else
                switch_point = m-1;
            end
        end
        if decreasing
            if AIF(2,m) < AIF(2,m-1)
                new_AIF(2,m) = AIF(2,m);
            else
                new_AIF(2,m) = new_AIF(2,switch_point) + down_slope(n);
            end
        else
            if m==1
                new_AIF(2,m) = 0;
            else
                new_AIF(2,m) = new_AIF(2,switch_point) + n*((1/interval)*up_slope);
            end
        end
    n = n+1;
    else
        if AIF(2,m) < AIF(2,m-1)
            new_AIF(2,m) = AIF(2,m);
        else
            new_AIF(2,m) = AIF(2,m) + new_AIF(2,pivot-1);
        end
    end
end

end