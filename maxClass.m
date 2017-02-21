function class = maxClass(label,classNumber)
maxNumOfclass     = 0;
for ithClass = 1 : classNumber 
      ithNumber = sum(label == ithClass);
      if(ithNumber > maxNumOfclass)
          maxNumOfclass = ithNumber;
          class         = ithClass;
      end  
end
end