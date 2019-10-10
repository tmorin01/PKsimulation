function output = get_zig_zag(up_slope, down_slope, start_t, end_t, time, interval)

output(1,:) = 0:(1/60):time;
decreasing = false;
n = 1;

for m=1:length(output)
    if output(1,m) < start_t
        output(2,m) = up_slope * output(1,m);
    elseif output(1,m) < end_t
        if n > (interval*60)
            decreasing = ~decreasing;
            n = 1;
        end
        if decreasing
            output(2,m) = output(2,m-1) + (down_slope);
            output(3,m) = 1;
        else
            output(2,m) = output(2,m-1) + (up_slope);
            output(3,m) = 0;
        end
    else
        output(2,m) = output(2,m-1);
    end
    n = n+1;
end

end