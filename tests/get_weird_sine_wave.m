function output = get_weird_sine_wave(time, amp, amp_factor, freq)

output = zeros(2,time .* 60 + 1);
output(1,:) = 0:(1/60):time;
output(2,:) = amp .* sin(freq .* output(1,:));

for m=1:length(output)
    if output(2,m) > 0
        output(2,m) = output(2,m) .* amp_factor;
    end
    output(2,m) = abs(output(2,m));
end

end