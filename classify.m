function [label, c] = classify(classifier,fd)
[label, score] = predict(classifier, fd);
if label == 1
    c = max(score);
else
    c = min(score);
end;