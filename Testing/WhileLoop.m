clear all
clc

%string = input("Please enter the string you wish to find: ", 's');
%threads = input("Please enter the number of files you wish to search though: ");

string = 'eeyad7';
threads = 8;
FileError = 1;
while FileError == 1
    try
        for num = 1:threads
            num
            file = fopen(['input' num '.txt'], 'r');
            fclose('all');
        end
        FileError = 0;
    catch
        fprintf("Files do not exist! \nCheck you entered the correct number.\n");
        %threads = input("Please enter the number of files you wish to search though: ");
        FileError = 1;
    end
end