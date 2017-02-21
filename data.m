[attrib1, attrib2, attrib3, attrib4, class] = textread('.\bezdekIris.data.txt', '%f%f%f%f%s', 'delimiter', ','); 
attrib = [attrib1'; attrib2'; attrib3'; attrib4']'; 
a = zeros(150, 1); 
a(strcmp(class, 'Iris-setosa')) = 1; 
a(strcmp(class, 'Iris-versicolor')) = 2; 
a(strcmp(class, 'Iris-virginica')) = 3; 
D=[attrib a];
rand = randperm(150);
trainSample = D(rand(1:70),:);

verifySample = D(rand(71:100),:);
% 
testSample = D(rand(101:150),:);
% save trainSample;
% save verifySample;
% save testSample;
% load trainSample;
% load verifySample;
% clear all;
% trainSample1 = load('LQIIDTrain.mat');
% trainSample1 = trainSample1.data;
% trainSample1((trainSample1(:,end) == -1),end) = 2;
% trainSample  = trainSample1(1:floor(size(trainSample1,1)/2),:) ;
% verifySample = trainSample1(ceil(size(trainSample1,1)/2):size(trainSample1,1),:);
% clear trainSample1;
% testSample = load('IntervalAll.mat');
% testSample = testSample.data;
% testSample((testSample(:,end) == -1),end) = 2;

numberOftree = 3; %É­ÁÖÖÐÊ÷µÄ¿ÃÊ÷
classTotal = zeros(50,numberOftree);
for i = 1 : numberOftree
% class = []; 
rand = randperm(70);
trainSample1 = trainSample(rand(1:60),:);
Tree0 = TreeGenerate(trainSample1,verifySample, 1);
% load Tree3.mat
[class,~] = test(testSample,Tree0);
clear Tree0;
classTotal(:,i) = class;
end
label = testSample(:,end);
class = zeros(length(label),1);
for ithSample = i : length(label)
class(ithSample) = maxClass(classTotal(ithSample,:), 3 );
end
accuracyRate = length( find((label-class) == 0) ) /length(label);
%  positiveClass = find(testSample(:,end)==1);
%  numberOfPositive = find(class(positiveClass)==1);
%  accuracyOfPositive = length(numberOfPositive)/length(positiveClass);
