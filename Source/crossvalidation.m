function [ testvals ] = crossvalidation(CMP,Xtrain,Ytrain,Wtrain,Xtest,Ytest,Wtest)
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here
Yfit = predict(CMP, Xtest);

testvals = mean(Ytest * log(Yfit) + (1 - Ytest) * log(1 - Yfit));

end

