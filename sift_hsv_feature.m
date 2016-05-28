% Build feature vector using visual dictionary
function fd = sift_hsv_feature(VOCopts,I)
warning('off','all');
% TODO: try to load the dictionary, if cannot launch bagOfWords
% dict = load('matfiles/dictionarySift200clusters.mat');
dict = load('matfiles/dictionarySiftHSV500clusters.mat');
K = dict.tree.K;
dict = dict.tree.centers;

hsv = rgb2hsv(I);

I = single(rgb2gray(I));
[f, d] = vl_sift(I);
hsFeat = zeros(4, size(f, 2));
for k = 1:size(f,2)
    x = floor(f(2, k));
    y = floor(f(1, k));
    s = floor(f(3, k));
    lx = x-s; rx = x+s;
    ly = y-s; ry = y+s;
    while(lx < 1), lx = lx + 1; end;
    while(rx > size(I,1)), rx = rx - 1; end;
    while(ly < 1), ly = ly + 1; end;
    while(ry > size(I,2)), ry = ry - 1; end;
    window = hsv(lx:rx, ly:ry,:);
    hsFeat(1, k) = mean(mean(window(:,:,1)));
    hsFeat(2, k) = std2(window(:,:,1));
    hsFeat(3, k) = mean(mean(window(:,:,2)));
    hsFeat(4, k) = std2(window(:,:,2));
end;
%         For each feature get mean of hue and saturation of the
%         neighbourhood
d(129:132,:) = hsFeat(:,:);
idx = knnsearch(dict',d', 'NSMethod', 'kdtree');

fd = zeros(1, K);
n = size(idx);
for i = 1:n
    fd(idx(i)) = fd(idx(i))+1;
end;

