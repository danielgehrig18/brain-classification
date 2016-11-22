%%
for s = 2:10    
    for b = 2:5
        % choose function and its parameters
        fun = 'MLP2_feature_extract3'; % TODO: modify function
        parameters = struct('x_segments', s, ... % TODO: optimize parameters through CV
                            'y_segments', s, ...
                            'z_segments', s, ...
                            'bins',b);

        X = generate_X('data/set_train', fun, parameters);
        save(['Xs/X_' num2str(s) '_' num2str(b) '.mat'], 'X'); 
    end
end

%%
y = csvread('targets.csv');

%%
for s = 2:10    
    for b = 2:5
        X_path = ['Xs/X_' num2str(s) '_' num2str(b) '.mat'];
        x_struct = load(X_path);
        X = x_struct.X;
        
        model = fitcensemble(X,y,'OptimizeHyperparameters','auto',...
            'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
            'expected-improvement-plus', 'MaxObjectiveEvaluations', 30, 'SaveIntermediateResults', 0, 'Verbose', 1, 'ShowPlots', 1, 'Kfold', 20));

        save(model, ['models/model_' num2str(s) '_' num2str(b) '.mat']);
    end
end
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