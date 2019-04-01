% "ezygnh" was found 25679 times in 4 files
% George Harper, 4282031
clear all; clc; %Reset the enviroment and delete all variables. Also clear the console.
delete(gcp('nocreate')) %delete/close any pools currently running. Close them at the start of the program as if you close it at the end of the program the variables are deleted which makes debugging really difficult. You can close it at the end to save memory but the trade off is that all composite variables are deleted. You cannot run more than one pool at once.
fclose('all'); %Make sure all files are closed before we start.

%-------------------------------end of setup-------------------------------

searchFor = input("Please enter the string you wish to find: ", 's'); %Take the string that is going to be searched for as a string
threads = input("Please enter the number of files you wish to search though: "); %The number of files that will be searched is equal to the number of threads on the program (so one thread will scan one file)
fprintf("Please enter the filename of the squential files that you wish to read.\nThey should have a number before the file extension.\nSo for 5 files called input1.txt, input2.txt, ..., input5.txt you should use a filename of \'input\' and 5 files.\nThese Files must be .txt files (i.e. have the .txt extension and be text files).\n")
filename = input("Please enter this case-sensitive filename: ", 's'); %Allows the name of the files to be entered

%-------------------------------start config-------------------------------
%Allow MATLAB to use any number of cores by setting the max to 32. I tried
%using 256 and crashed the computer as I ran out of page file and memory!
%Only way to fix was a forced restart with the power button.
myCluster = parcluster('local');  %Chooses the local profile as this is the default
myCluster.NumWorkers = 32;  %Allows a maximum of 32 workers/threads
saveProfile(myCluster); %Saves the changes
parpool(threads); %Start with this number of threads
%--------------------------------end config--------------------------------

FileError = true; %Sets the file error to true as right now the status of the files is unknown (i.e. if they can be opened)
while FileError == true
    try
        for num = 1:threads %For each thread and therefore file run the following
            file = fileread([filename num2str(num) '.txt']); %Try and read the file. This will return the contents of the file or -1 if there is an error.
            if file == -1 %Fileread returns -1 if the file cannot be opened.
                a = CatchError(1); %Hacky way of catching an error. If the file does not exist then call a non-existant function which will throw an error then execute the catch code.
            end
        end
        fclose('all'); %Close all files as they will be opened later, we know they exist now.
        FileError = false; %All the files have been opened successfully so fileerror is false as there isn't one
    catch
        FileError = true;
        fclose('all'); %Close all files on an error. Maybe the files are locked?
        fprintf("The file: %s cannot be found or opened! \nCheck you entered the correct number of files, the correct filename and ensure that the file is not locked.\n", [filename num2str(num) '.txt']); %Warns the user the following file cannot be opened and asks them to check if it exists and is not locked
        filename = input("Please enter the correct filename: ", 's'); %Prompt user for the correct filename
        threads = input("Please enter the number of files you wish to search though: "); % Promt user for the correct number of files.
    end
end

spmd(threads)
    id = labindex; % Finds the worker ID, so thread 1 will give an ID of 1. This allows each filename to be searched by each worker
    filetext = fileread([filename num2str(id) '.txt']); %Concatenate variables so the output of this will be 'filename + id + .txt' to give filenameid.txt where id is a integer
    locations = strfind(filetext,searchFor); %Search each file for the string given
    count = numel(locations); %Count the number of times that the string has been found.
end

final_total = 0; %Set the final total to 0
for i = 1:length(count) %For each item add the count to the final total
    final_total = final_total + count{i};
end

fprintf('The string \"%s\" occured %d times in %d files.\n',searchFor, final_total, threads);
fprintf('These %d files were: \n',threads); %Print the results of the search
for count = 1:threads %For each filename print it to the console
    FileNameToPrint = [filename num2str(count) '.txt'];
    fprintf("%s\n",FileNameToPrint);
end

fclose('all'); %Close all files as we have finished working with them. Otherwise the file will be locked in future runs and may cause instablity.