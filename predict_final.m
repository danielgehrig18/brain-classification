% main - main pipeline for training b with a training set from
% 'data/set_train' folder and 'data/targets.csv' and prediction of test data from
% 'data/set_test' folder. Train_b is optimized for best BIC (Bayesian Information Criterion), a compromise between model
% complexity and accuracy. The resulting file to be submited will be
% generated as 'data/submit.csv'.

% add relevant folder to path
addpath('feature extract', 'Source','ReadData3D_version1k/nii');

%% choose function and its parameters
fun = 'feature_extract_3peaks';
parameters = struct('cgone', 220, ...
                     'cgtwo', 750, ...
                     'cgthree', 1450, ...
                     'rangeone', 50, ...
                     'rangetwo', 35, ...
                     'rangethree', 110);

% train model with Matlab function LinearModel.fit
[model, X] = train_b('data/set_train', 'targets.csv', fun, parameters);                    

%% generate submission file from test set and resulting model
disp('Training finished successfully!');
disp('Creating submission file using Data: data/set_test...');

submission('data/set_test', 'submit.csv', model, fun, parameters);

disp('Submission file created successfully!');