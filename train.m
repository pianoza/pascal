function classifier = train(VOCopts,cls)
% load 'train' image set for class
[ids, gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');

tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: train: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end

    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
        cl.Training(i,:) = fd;
        cl.Group(i) = gt(i);
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd = extractfd(VOCopts, I); % training vector
        cl.Training(i,:) = fd;
        cl.Group(i) = gt(i);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
end
% classifier = svmtrain(cl.Training, cl.Group');
classifier = fitcsvm(cl.Training, cl.Group');
