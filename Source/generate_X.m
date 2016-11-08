function [ X ] = generate_X(folder, fun, parameters)
%GENERATE_X Generate the data matrix from data in folder. The function used
%the function fun with parameters parameters to generate features. 
%   Args:   folder:     folder with all the training data for X
%           fun:        function to be used for the feature extraction
%           parameters: struct containing all relevant arguments to execute
%                       fun
%
%   Return: X:     Data matrix (# datapoints) x (# features) 

% iterates through files in folder
files = dir(folder);
for file = files'
    file_name = file.name;

    % skips system files (e.g. '.filename')
    if file_name(1) == '.'
        continue
    end
    
    % finds file number (file of the form 'test_3.nii')
    parse1 = strsplit(file_name, '.');
    parse2 = strsplit(parse1{1}, '_');
    file_number = str2num(parse2{2});
        
    % constructs file path
    path_name = strcat(folder, '/', file_name);
    
    % extract features from file
    feature_extract = str2func(fun);
    x = feature_extract(path_name, parameters);
    
    % writes feature in appropriate row
    X(file_number, :) = x;
end
end

