% Build feature vector using visual dictionary
function fd = sift_hsv_point_feature(VOCopts,I)
warning('off','all');
% TODO: try to load the dictionary, if cannot launch bagOfWords
% dict = load('matfiles/dictionarySift200clusters.mat');
dict = load('matfiles/dictionarySiftHSVPoints500clusters.mat');
K = dict.tree.K;
dict = dict.tree.centers;

hsv = rgb2hsv(I);

I = single(rgb2gray(I));
[f, d] = vl_sift(I);
hsFeat = zeros(2, size(f, 2));
for k = 1:size(f,2)
    x = round(f(2, k));
    y = round(f(1, k));
    hsFeat(1, k) = hsv(x, y, 1);
    hsFeat(2, k) = hsv(x, y, 2);
end;
d(129:130,:) = hsFeat(:,:);
idx = knnsearch(dict',d', 'NSMethod', 'kdtree');

fd = zeros(1, K);
n = size(idx);
for i = 1:n
    fd(idx(i)) = fd(idx(i))+1;
end;







