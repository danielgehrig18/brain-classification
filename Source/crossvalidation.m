function [ testvals ] = crossvalidation(CMP,Xtrain,ytrain,Wtrain,Xtest,ytest,Wtest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

load('model_final.mat');
% template tree parameters
tree = model.ModelParameters.LearnerTemplates{1};

% get parameters 
n_learn = model.ModelParameters.NLearn;
method = model.ModelParameters.Method;
model = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'LearnRate', learning_rate, 'Learners', tree); 

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


