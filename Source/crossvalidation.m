function [ testvals ] = crossvalidation(CMP,Xtrain,ytrain,Wtrain,Xtest,ytest,Wtest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
global s b i
load_path = ['models/model_' num2str(s) '_' num2str(b) '.mat'];


m = load(load_path);
m = m.model;
% template tree parameters
tree = m.ModelParameters.LearnerTemplates{1};

% get parameters 
n_learn = m.ModelParameters.NLearn;
method = m.ModelParameters.Method;
if ~strcmp(method, 'Bag')
    learning_rate = m.ModelParameters.LearnRate;
    m = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'LearnRate', learning_rate, 'Learners', tree); 
else
    m = fitcensemble(Xtrain, ytrain, 'Method', method, 'NumLearningCycles', n_learn, 'Learners', tree); 
end

[~,scores] = predict(m, Xtest);

yfit = scores(:,2);

if ~strcmp(method, 'Bag')
    yfit = 1 ./ (1 + exp(-i*yfit));
end

testvals = -mean(ytest .* log(yfit) + (1 - ytest) .* log(1 - yfit));
end


