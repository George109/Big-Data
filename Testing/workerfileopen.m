clear all
clc

%string = input("Please enter the string you wish to find: ", 's');
string = 'eeyad7';
file = fopen(['input' 1 '.txt'], 'r');
filetext = fileread('input1.txt');
locations = strfind(filetext,string);
count = numel(locations);
fprintf('The string \"%s\" occured %d times.\n',string, count);
fclose('all');
