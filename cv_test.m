%%
is = .2:.2:2;
global s b i 
for s=3:10
    for b=2:5
        ms = [];
        std = [];
        model_s = load(['models/model_' num2str(s) '_' num2str(b) '.mat']);
        model = model_s.model;
            
        cv_model = crossval(model); % TODO: way to pass model function and parameters
            
        for i=is
            CV = kfoldfun(cv_model, @crossvalidation);
            m = mean(CV);
            ms = [ms, m];
            std = [std, mean((CV-m).^2)^.5];
        end
        
        save(['ms/ms_' num2str(s) '_' num2str(b) '.mat'], 'ms');
        save(['stds/std_' num2str(s) '_' num2str(b) '.mat'], 'std');
        disp(['saved for params: b = ' num2str(b) ' and s = ' num2str(s) ' and method ' model.Method]);
    end
end

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
model = fitcensemble(X,y,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus', 'MaxObjectiveEvaluations', 30, 'SaveIntermediateResults', 0, 'Verbose', 1, 'ShowPlots', 1, 'Kfold', 20));

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