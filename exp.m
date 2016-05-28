%% Init
addpath([cd '/VOCcode']);
VOCinit;
cls=VOCopts.classes{1};

[ids, gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');

%% Train

for i=1:length(ids)
    I=imread(sprintf(VOCopts.imgpath,ids{i}));
    fd.FVector = extractfd(VOCopts, I); % training vector
    fd.Gt = gt(i); % training group
    cl.Training(i,:) = fd.FVector;
    cl.Group(i) = gt(i);
end
fprintf('Started training...');
% classifier = svmtrain(cl.Training, cl.Group', 'kernel_function', 'quadratic');
classifier = fitcsvm(cl.Training, cl.Group', 'KernelFunction', 'polynomial');

%% Test
[ids, gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'val'),'%s %d');
count = 0;
for i=1:length(ids)
    I=imread(sprintf(VOCopts.imgpath,ids{i}));
    fd.FVector=extractfd(VOCopts,I);
    fd.Gt = gt(i);
    [c, f] = predict(classifier, fd.FVector);
    res = 'false';
    if c == gt(i)
        res = 'true';
        count = count + 1;
    end;
    if c==1
        score = f(1);
    else
        score = f(2);
    end;
    fprintf('Image: %d; group: %d; classified: %d; confidence: %f; Result: %s\n', i, gt(i), c, score, res);
end
fprintf('Correct classifications %d out of %d\n', count, length(ids));
