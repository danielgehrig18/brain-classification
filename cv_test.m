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

for s = 2:10    
    for b = 9:10
        model = load(['models/model_' num2str(s) '_' num2str(b) '.mat']);
         model = model.model;
        cv_model = crossval(model); % TODO: way to pass model function and parameters
%         is = .1:.1:1;
        
        for i=.1:.1:1
            save('i.mat', 'i');
            save('s.mat', 's');
            save('b.mat', 'b');
            CV = kfoldfun(cv_model, @crossvalidation);

            m = mean(CV);
            ss = mean((CV-m(end)).^2)^.5;
            
            result = [s, b, i, m, ss];
            
            disp(['For s = ' num2str(s) ' b = ' num2str(b) ' i = ' num2str(i) ' -- m = ' num2str(mean(CV)) ' -- ss = ' num2str(mean((CV-m(end)).^2)^.5)])
            
        end
    end
end
save('result.mat', 'result');