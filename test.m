%test.m 
function [class, accurcyRate] = test(testSample,tree)
label      = testSample(:,end);
testSample = testSample(:,1:end-1);
class      = zeros(size(label));

for jthSample = 1 : size(testSample,1)
    ithNode    = 1;
    while class(jthSample) == 0
    if tree.isleaf(ithNode) == 1
        class(jthSample) = tree.class(ithNode);
    else
%         class(jthSample) = 0;
        feature   = tree.feature(ithNode);
        threshold = tree.threshold(ithNode);
        child     = tree.child{ithNode};
        if((testSample(jthSample,feature)) <= threshold)
            ithNode = child(1);
        else
            ithNode = child(2);
        end  
    end 
    end
end

accurcyRate = length( find((label-class) == 0) ) /length(label);


