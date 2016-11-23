function [ model, CV] = train( x_folder, y_file, fun, parameters )
%TRAIN_B Trains a classification model with Matlab function LinearModel.fit
%   Args:   x_folder:   folder with all the training data for X
%           y_file:     file with the training data for y
%           fun:        function to be used for the feature extraction
%           parameters: struct containing all relevant arguments to execute
%                       fun
%
%   Return: model: object of type LinearModel containing a trained model
%                  with training set
%           X:     Data matrix (# datapoints) x (# features) 

% loads targets
y = csvread(y_file);

% generates #datapoints x (#features) data matrix
X = generate_X(x_folder, fun, parameters); 

% creates linear model
<<<<<<< HEAD
model = LinearModel.fit(X,y, 'RobustOpts', 'on', 'Weights', w);
end
=======
% TODO: modify fitcensemble parameters to customize CV
% TODO: extract parameters from optimized model to generate model manually
% TODO: optimize other parameters in fitcensemble (´auto´, ´gridsearch´)
model = fitcensemble(X,y,'OptimizeHyperparameters','auto',... 
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus', 'Kfold', 10));

% crossvalidate
cv_model = crossval(model); % TODO: way to pass model function and parameters
CV = kfoldfun(cv_model, 'crossvalidation');
>>>>>>> f83786522962ef707dce42d732a2a1f0900438ff
