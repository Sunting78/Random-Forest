function   tree = cutTree(verifySample,tree)
       [~ ,accuracy] = test(verifySample,tree);
       originAccuracy = accuracy;
       nonleafNodeAll   = find(tree.isleaf == 0);
       disp(sprintf('All %d leafnode', length(nonleafNodeAll)));
       for  ithNonleaf = length(nonleafNodeAll): -1: 1 
           disp(sprintf('Cut %dth leafnode', ithNonleaf));
           nonleafNode = nonleafNodeAll(ithNonleaf);
           tree.class(nonleafNode) = tree.nodeclass(nonleafNode);
           tree.isleaf(nonleafNode) = 1;
           
           [~ ,accuracy] = test(verifySample,tree);
           if(accuracy < originAccuracy)
           tree.class(nonleafNode) = 0;
           tree.isleaf(nonleafNode) = 0;
           else
           originAccuracy = accuracy ;
           end
       end