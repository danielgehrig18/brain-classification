function [ testvals ] = crossvalidation(Xtrain,ytrain, Xtest,ytest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

m = fitcsvm(Xtrain, ytrain, 'KernelFunction','RBF', 'KernelScale','auto');
[~,scores] = predict(m, Xtest);
yfit = 1 ./ (1 + exp(-scores(:, 2)));

testvals = -mean(ytest .* log(yfit) + (1 - ytest) .* log(1 - yfit));

end


