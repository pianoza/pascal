% Build feature vector using visual dictionary
function fd = extractfd(VOCopts,I)
warning('off','all');
% TODO: try to load the dictionary, if cannot launch bagOfWords
% dict = load('matfiles/dictionarySift200clusters.mat');
dict = load('matfiles/nova_dictionaryRGBeachChannelDSift200BoW.mat');
K = size(dict.C, 1);
dict = dict.C';

rgb = I;
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
fdd = [dr, dg, db, d];

idx = knnsearch(dict', fdd', 'NSMethod', 'kdtree');

fd = zeros(1, K);
n = size(idx);
for i = 1:n
    fd(idx(i)) = fd(idx(i))+1;
end;
tl = 0;


