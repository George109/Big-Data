clear all
clc
delete(gcp('nocreate')) %delete/close any pools currently running. Close them at the start of the program as it makes debugging really difficult as closing it and the end of the program deletes the variables which makes debugging really hard to do.

%-------------------------------end of setup-------------------------------
%searchFor = input("Please enter the string you wish to find: ", 's');
%threads = input("Please enter the number of files you wish to search though: ");

searchFor = 'eeypr';
threads = 4;
%-------------------------------start config-------------------------------

%Allow MATLAB to use any number of cores by setting the max to 32. I tried
%using 256 and crashed the computer as I ran out of page file and memory!
%Only way to fix was a forced restart with the power button.
myCluster = parcluster('local'); 
myCluster.NumWorkers = 32; 
saveProfile(myCluster);


parpool(threads); %Start with this number of threads

%--------------------------------end config--------------------------------

FileError = 1;
while FileError == 1
    try
        for num = 1:threads
            file = fileread(['input' num2str(num) '.txt']);
            if file == -1 %Fileread returns -1 if the file cannot be opened.
                a = CatchError(1); %Hacky way of catching an error. If the file does not exist then call a non-existant function which will throw an error then execute the catch code.
            end
            fclose('all'); %Close all files as they will be opened later.
        end
        FileError = 0;
    catch 
        fprintf("The file: %s \n cannot be found or opened! \nCheck you entered the correct number of files and that the file is not locked.\n", ['input' num2str(num) '.txt']);
        %threads = input("Please enter the number of files you wish to search though: ");
        threads = 4;
        FileError = 1;
    end
end


spmd(threads)
    id = labindex;
    filetext = fileread(['input' num2str(id) '.txt']);
    locations = strfind(filetext,searchFor);
    count = numel(locations);
end

final_total = 0;
for i = 1:length(count)
    final_total = final_total + count{i};
end

fprintf('The string \"%s\" occured %d times in %d files.\n',searchFor, final_total, threads);
fclose('all');