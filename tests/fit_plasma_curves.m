A1 = dlmread('plasma_art1.bld','\t',1,0);
A2 = dlmread('plasma_art2.bld','\t',1,0);
A3 = dlmread('plasma_art3.bld','\t',1,0);
A4 = dlmread('plasma_art4.bld','\t',1,0);

lists = {A1, A2, A3, A4};
new_list = zeros(0,2);
for m=1:4
    cur = lists{m};
    for n=1:length(cur)
        if cur(n,1) < 3500
            new_list(end+1,:) = cur(n,:);
        end
    end
assignin('base','new_list',new_list);
end

