spmd
    mynumber = rand(1,1);
    display(mynumer);
end

total = 0;
for i = 1:length(mynumber)
    total = total + mynumber{i};
end
fprintf('Total: %d\n', total);
