% run classifier on test images
function test(VOCopts,cls,classifier)
% addpath([cd '/VOCcode']);
% 
% % initialize VOC options
% VOCinit;
% cls=VOCopts.classes{1};
% load test set ('val' for development kit)
[ids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,VOCopts.testset),'%s %d');

% create results file
fid=fopen(sprintf(VOCopts.clsrespath,'comp1',cls),'w');
% classify each image
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: test: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    [label, c] = classify(classifier, fd);
    % write to results file
    fprintf(fid,'%s %f\n',ids{i},c);
    fprintf('Result: image %s; score: %f; group: %d; classified: %d\n',cls,c,gt(i),label);
end
% close results file
fclose(fid);