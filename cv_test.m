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

        save(['models/model_' num2str(s) '_' num2str(b) '.mat'], 'model');
    end
end
%%
cv_model = crossval(model); % TODO: way to pass model function and parameters
is = .1:.2:2;
ms = [];
std = [];
global s b i 
for s=2:10
    for b=2:5
        for i=is
            CV = kfoldfun(cv_model, @crossvalidation);
            ms = [ms, mean(CV)];
            std = [std, mean((CV-m(end)).^2)^.5];
        end
        save(['ms/ms_' num2str(s) '_' num2str(b) '.mat'], 'ms');
        save(['stds/std_' num2str(s) '_' num2str(b) '.mat'], 'std');
    end
end

