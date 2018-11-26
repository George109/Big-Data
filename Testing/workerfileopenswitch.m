clear all
clc
delete(gcp('nocreate')) %delete/close any pools currently running. Close them at the start of the program as it makes debugging really difficult as closing it and the end of the program deletes the variables which makes debugging really hard to do.

%string = input("Please enter the string you wish to find: ", 's');
%threads = input("Please enter the number of files you wish to search though: ");

string = 'eeyad7';
threads = 4;
%-----------------
%Allow MATLAB to use any number of cores by setting the max to 32. I tried
%using 256 and crashed the computer as I ran out of page file and memory!
%Only way to fix was a forced restart with the power button.
myCluster = parcluster('local');
myCluster.NumWorkers = 32;
saveProfile(myCluster);
%--------------------
parpool(threads);
feature('numcores');

spmd(threads)
    
    total = 0;
    id = labindex;
    switch id
        case 1
            filetext = fileread(['input' + id + '.txt']);
            locations = strfind(filetext,string);
            count = numel(locations);
            fclose('all');
        case 2
            file = fopen(['input' id '.txt'], 'r');
            filetext = fileread('input1.txt');
            locations = strfind(filetext,string);
            count = numel(locations);
            fclose('all');
        case 3
            file = fopen(['input' id '.txt'], 'r');
            filetext = fileread('input1.txt');
            locations = strfind(filetext,string);
            count = numel(locations);
            fclose('all');
        case 4
            file = fopen(['input' id '.txt'], 'r');
            filetext = fileread('input1.txt');
            locations = strfind(filetext,string);
            count = numel(locations);
            fclose('all');
    end
end

final_total = 0;
for i = 1:length(count)
    final_total = final_total + count{i};
end

fprintf('The string \"%s\" occured %d times in %d files.\n',string, final_total, threads);
fclose('all');