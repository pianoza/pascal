% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);
addpath([cd '/ColorDescriptors']);

% initialize VOC options
VOCinit;

% train and test classifier for each class
for i=1:1%VOCopts.nclasses
    cls=VOCopts.classes{i};
    classifier=train(VOCopts,cls);                  % train classifier
    test(VOCopts,cls,classifier);                   % test classifier
    [fp,tp,auc]=VOCroc(VOCopts,'comp1',cls,true);   % compute and display ROC
    if i<VOCopts.nclasses
        fprintf('press any key to continue with next class...\n');
        pause;
    end
end
