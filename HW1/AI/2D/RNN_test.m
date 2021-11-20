function y = RNN_test(para)

Whh = reshape(para(1:9),[3,3]);
Wxh = reshape(para(10:21),[3,4]);
bh = para(22:24)';
Why = reshape(para(25:36),[4,3]);
by = para(37:40)';

h = zeros(3,1);
x = [1 0 0 0]';
y = zeros(4,4);

for t = 1:4
    h = tanh(Whh*h + Wxh*x + bh);
    y(:,t) = softmax(Why*h + by);
    x = y(:,t);
end
