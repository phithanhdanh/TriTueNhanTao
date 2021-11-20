function f = RNN_cost2(para)
Whh = reshape(para(1:9),[3,3]);
Wxh = reshape(para(10:21),[3,4]);
bh = para(22:24)';
Why = reshape(para(25:36),[4,3]);
by = para(37:40)';

h = zeros(3,1);
x = [1 0 0 0]';
target = [0 0 0 0
          1 0 0 0
          0 1 1 0
          0 0 0 1]; 
y = zeros(4,4);
loss = 0;

for t = 1:4
    h = tanh(Whh*h + Wxh*x + bh);
    y(:,t) = softmax(Why*h + by);    
    loss = loss + sum(-log2(y(:,t)) .* target(:,t));
    x = y(:,t);
end
f = loss;