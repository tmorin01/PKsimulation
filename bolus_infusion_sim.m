function plot_data = bolus_infusion_sim(TAC, t, competition, noise, chal_times, handles, num)

assignin('base','num',num);
for m=1:num
   TAC(m,:) = noiseModel(t, TAC(m,:), handles, noise);
   plot_data.x(m,:) = t(1,:);
   plot_data.y(m,:) = TAC(m,:);
   assignin('base','plot_data',plot_data);
end

plot_data.NT(1,1:length(t)) = 100;

end