function [ criterion ] = cv( XTRAIN, ytrain, XTEST, ytest )
%CV Summary of this function goes here
%   Detailed explanation goes here
mdl = fitcsvm(XTRAIN, ytrain, 'KernelFunction', 'RBF', 'KernelScale', 'auto');

[~, score] = predict(mdl, XTEST);

yfit = 1./(1+exp(-2*score(:,2)));

criterion = -mean(ytest .* log(yfit) + (1 - ytest) .* log(1-yfit));

end
