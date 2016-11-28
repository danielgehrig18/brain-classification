%%
for s = 2:10    
    for b = 6:8
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
SaveM = cell(3,1);
bvec = 6:8;
disp('Evaluation started')
tic
% for s = 2:10    
%     parfor c = 1:3
%         b = bvec(c);
%         X_path = ['Xs/X_' num2str(s) '_' num2str(b) '.mat'];
%         x_struct = load(X_path);
%         X = x_struct.X;
        c = 1;
        SaveM{c} = fitcensemble(X,y,'OptimizeHyperparameters','auto',...
            'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
            'expected-improvement-plus', 'MaxObjectiveEvaluations', 30, 'SaveIntermediateResults', 0, 'Verbose', 1, 'ShowPlots', 1, 'Kfold', 20));

        
%     end
%     disp(['Evaluated ' num2str(s)])
%     for c = 1:3
%         b = bvec(c);
        model = SaveM{c};
%         save(['models/model_' num2str(s) '_' num2str(b) '.mat'], 'model');
%     end
%     disp(['Saved ' num2str(s)])
% end
disp('Evaluation completed')
t = toc;

%%
global globmodel iparameter
SaveCVmean = cell(10,1);
SaveCVstd = cell(10,1);
SaveCVstrange = cell(10,1);
irange = 0.2:0.2:2;
brange = 6:8;
srange = 2:9;
tottime = 0;
disp('Cross validiation started ...')
for i= 1:length(irange)
    iparameter = irange(i);
    CVmeanmat = zeros(8,3);
    CVstrangemat = CVmeanmat;
    CVstdmat = CVmeanmat;
for is = 1:length(srange)
    s = srange(is);
    for ib = 1:length(brange)
        tic
        b = brange(ib);
        load(['models/model_' num2str(s) '_' num2str(b) '.mat']) 
        globmodel = model;
        cv_model = crossval(model); % TODO: way to pass model function and parameters          
%     save('i.mat', 'i');
            CV = kfoldfun(cv_model, @crossvalidation);
            tempmean = mean(CV);
            CVmeanmat(is,ib) = tempmean;
            CVstrangemat(is,ib) = mean((CV-tempmean(end)).^2).^5;
            CVstdmat(is,ib) = std(CV);
            
%             s = [s, mean((CV-m(end)).^2)^.5];
            t = toc;
            tottime = tottime + t;
            disp(['Cross validation of ' num2str(s) ' chunks and ' num2str(b) ' bins and i parameter ' num2str(iparameter) ' done in ' num2str(t) ' seconds.'])
            disp(['CV mean ' num2str(CVmeanmat(is,ib)) ', CV deviation ' num2str(CVstdmat(is,ib)) ' Total elapsed time ' num2str(tottime)])
    end
end
    SaveCVmean{i} = CVmeanmat;
    SaveCVstrange{i} = CVstrangemat;
    SaveCVstd{i} = CVstdmat;
end
disp('Cross validation completed')
clearvars globmodel iparameter