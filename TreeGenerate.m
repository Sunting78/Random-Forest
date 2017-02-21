function tree = TreeGenerate(trainSample,verifySample,isCut)
%%%%%% 2016.12.29 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   输入：训练集 验证集
%   输出：决策树模型
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classNumber = 3; 
n           = 1; 
node        = 1;

while( n <= node )
    disp(sprintf('At %dth node',n));
if(n ~= 1)
for father = n-1 : -1 : 1
index = find(tree.child{father} == n);
if index == 1
    trainSample = tree.leftData{father};
    break;
end
if index == 2
    trainSample = tree.rightData{father};
    break;
end
end
end

label = trainSample(:,end);
class = maxClass(label,classNumber);
tree.nodeclass(n) =class;
% tree.trainSample{n} = trainSample;


if(length(unique(trainSample(:,end))) == 1|| sum(sum((trainSample(:,1:end-1)-repmat(trainSample(1,1:end-1),size(trainSample,1),1)))) == 0)
    %判断为叶子节点的  1. data全都一样 2. data都属于1个类 
tree.feature(n)   = 0;
tree.threshold(n) = 0;
tree.child{n}     = [0,0];
tree.leftData{n}  = 0;
tree.rightData{n} = 0;
% tree.issplit(n)   = 0;
tree.isleaf(n)    = 1;

tree.class(n) = class;


else 
    
[feature,threshold,leftData,rightData] = splitnode(trainSample,classNumber); 
tree.feature(n)   = feature;
tree.threshold(n) = threshold;
tree.child{n}     = [node+1,node+2];
tree.leftData{n}  = leftData;
tree.rightData{n} = rightData;
%  tree.issplit(n)   = 1;
tree.isleaf(n)    = 0;
tree.class(n)     = 0;  
             node = node + 2;
                 
end
      n  = n + 1;  
end
if isCut == 1
        tree = cutTree(verifySample,tree);
end
end



function [feature,threshold,leftData,rightData]=splitnode(data,classNumber) 
% maxEntropy = 0;
numberOfsample = size(data,1);
label          = data(:,end);
% nthIter = 1;
gainMatric     = zeros(size(data,2)-1,3);
for ithFeature = 1:size(data,2)-1
    subData = data(:,ithFeature);
    entropy = Entropy(label,classNumber);
    maxEntropy = 0;
    
if  max(subData) - min(subData) < 0.001
    continue;
end
    
    for jthThreshold = min(subData) : 0.05 : max(subData)-0.001
    
       leftIndex = subData <= jthThreshold; numberOfleft = sum (leftIndex);
       rightIndex = subData > jthThreshold; numberOfright = sum (rightIndex);
       entropyOfleft = Entropy(label(leftIndex),classNumber);
       entropyOfright = Entropy(label(rightIndex),classNumber);
       Gain = entropy - (entropyOfleft * numberOfleft + entropyOfright *  numberOfright) / numberOfsample;

       if (Gain > maxEntropy)  
           maxEntropy = Gain;
           threshold  = jthThreshold;
           
           feature   = ithFeature;
           leftData   = data(leftIndex,:);
           rightData  = data(rightIndex,:);
       end    
       
    end
%     gainMatric(ithFeature,:) = [maxEntropy,ithFeature,threshold];
   
end
%          gainMatric = sortrows(gainMatric,1);
%          randNum   = rand(1,1);
%          feaThres  = gainMatric(end,:);
%          feature   = feaThres(2);
%          threshold = feaThres(3);
%          
%         if (randNum > 0.65)
%             feaThres  = gainMatric(end-1,:);
%             feature   = feaThres(2);
%             threshold = feaThres(3); 
%         end
%         
%        subData    = data(:,feature);
%        leftIndex  = subData <= threshold; 
%        rightIndex = subData > threshold; 
%        leftData   = data(leftIndex,:);
%        rightData  = data(rightIndex,:);
end


function E = Entropy(label,classNum)
totalNum = length(label);
entropy  = zeros(classNum,1);
for ithClass = 1 : classNum
    numberOfclass = length(find(label == ithClass))/totalNum;
    if numberOfclass == 0
        entropy(ithClass) = 0;
    else
        entropy(ithClass) = numberOfclass * log2(numberOfclass);
    end
end
E = -sum(entropy(:));
end