function [ testvals ] = crossvalidation(CMP,Xtrain,ytrain,Wtrain,Xtest,ytest,Wtest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

m = load('models/model.mat');
m = m.model;
% template tree parameters
tree = m.ModelParameters.LearnerTemplates{1};

% get parameters 
n_learn = m.ModelParameters.NLearn;
learning_rate = m.ModelParameters.LearnRate;
method = m.ModelParameters.Method;
m = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'LearnRate', learning_rate, 'Learners', tree); 

[~,scores] = predict(m, Xtest);

yfit = scores(:,2);

if ~isempty(find(yfit < 0 | yfit > 1))
    i = load('i.mat');
    i.i
    yfit = 1 ./ (1 + exp(-i.i*yfit));
end

testvals = -mean(ytest .* log(yfit) + (1 - ytest) .* log(1 - yfit));
end


