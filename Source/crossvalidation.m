function [ testvals ] = crossvalidation(CMP,Xtrain,ytrain,Wtrain,Xtest,ytest,Wtest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

% m = load('models/model.mat');
% m = m.model;
% template tree parameters
global globmodel iparameter
tree = globmodel.ModelParameters.LearnerTemplates{1};

% get parameters 
n_learn = globmodel.ModelParameters.NLearn;
learning_rate = globmodel.ModelParameters.LearnRate;
method = globmodel.ModelParameters.Method;
if strcmp(method,'Bag')
    % LearnRate is not an option of bagging
    m = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'Learners', tree);
else
    m = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'LearnRate', learning_rate, 'Learners', tree); 
end

[~,scores] = predict(m, Xtest);

yfit = scores(:,2);

idxTrans = (yfit > 0 & yfit < 1);

if sum(idxTrans) < length(idxTrans) 
%     i = load('i.mat');
%     i.i
    yfit = 1 ./ (1 + exp(-iparameter*yfit));
end

testvals = -mean(ytest .* log(yfit) + (1 - ytest) .* log(1 - yfit));
end


