%% choose function and its parameters
fun = 'MLP2_feature_extract3'; % TODO: modify function
parameters = struct('x_segments', 9, ... % TODO: optimize parameters through CV
                    'y_segments', 9, ...
                    'z_segments', 9, ...
                    'bins',3);
                
X = generate_X('data/set_train', fun, parameters);
%%
y = csvread('targets.csv');

%%
model = fitcensemble(X,y,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus', 'MaxObjectiveEvaluations', 100, 'SaveIntermediateResults', 0, 'Verbose', 1, 'ShowPlots', 1, 'Kfold', 20));

save(model, 'models/model.mat');
%%
cv_model = crossval(model); % TODO: way to pass model function and parameters
is = .1:.1:1;
ms = [];
ss = [];
for i=.1:.1:1
    save('i.mat', 'i');
    i
    CV = kfoldfun(cv_model, @crossvalidation);
    m = [m, mean(CV)];
    s = [s, mean((CV-m(end)).^2)^.5];
end