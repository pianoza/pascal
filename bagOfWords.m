addpath([cd '/VOCcode']);
addpath([cd '/ColorDescriptors']);
addpath([cd '/ColorDetectors']);
% initialize VOC options
VOCinit;
numClusters = 700;
% nleaves = 5000;
features = [];

for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
    [ids, gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'bow'),'%s %d');
    for j = 1:length(ids)
        fprintf('%s: dictionary: %d/%d\n',cls,j,length(ids));
        rgb = imread(sprintf(VOCopts.imgpath,ids{j}));
        im = single(rgb2gray(rgb));
        [~, d] = vl_sift(im);
        r = single(rgb(:,:,1));
        g = single(rgb(:,:,2));
        b = single(rgb(:,:,3));
        [~, dr] = vl_sift(r);
        [~, dg] = vl_sift(g);
        [~, db] = vl_sift(b);
        dr = double(dr);
        dg = double(dg);
        db = double(db);
        d = double(d);
        features = [features, dr, dg, db, d];
        fprintf('feature size %dx%d\n', size(features, 1), size(features, 2));
    end;
end;
% features = uint8(features);
fprintf('feature size %dx%d\n', size(features, 1), size(features, 2));
% [tree, A] = vl_hikmeans(features, numClusters, nleaves);
[idx, C] = kmeans(features', numClusters, 'Display', 'iter');

save 'matfiles/nova_dictionaryRGBeachChannelDSift200BoW.mat' C;
fprintf('Dictionary is saved!\n');
