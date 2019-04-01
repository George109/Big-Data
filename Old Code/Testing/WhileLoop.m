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
            file = fileread(['input' num2str(num) '.txt']);
            if file == -1
                a = CatchError(1,2);
            end
            fclose('all');
        end
        FileError = 0;
    catch 
        fprintf("The file: %s \n cannot be found or opened! \nCheck you entered the correct number of files and that the file is not locked.\n", ['input' num2str(num) '.txt']);
        %threads = input("Please enter the number of files you wish to search though: ");
        threads = 4;
        FileError = 1;
    end
end
fclose('all');