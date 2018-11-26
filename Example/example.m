%------------------
%Allow MATLAB to use any number of cores by setting the max to 32. I tried
%using 256 and crashed the computer as I ran out of page file and memory!
%Only way to fix was a forced restart with the power button.
myCluster = parcluster('local'); 
myCluster.NumWorkers = 32; 
saveProfile(myCluster);
%--------------------
parpool(8);
feature('numcores');

spmd
    mynumber = rand(1,1);
    display(mynumber);
end

total = 0;
for i = 1:length(mynumber)
    total = total + mynumber{i};
end
fprintf('Total: %d\n', total);

%delete(gcp('nocreate'))