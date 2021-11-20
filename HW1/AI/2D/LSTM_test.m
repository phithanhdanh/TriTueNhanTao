function y = LSTM_test(para)

Wf = reshape(para(1:21),[3,7]);     
Wi = reshape(para(22:42),[3,7]);
Wc = reshape(para(43:63),[3,7]);
Wo = reshape(para(64:84),[3,7]);

bf = para(85:87)';
bi = para(88:90)';
bc = para(91:93)';
bo = para(94:96)';

Why = reshape(para(97:108),[4,3]);
by = para(109:112)';

h = zeros(3,1);
C = h;
x = [1 0 0 0
     0 1 0 0
     0 0 1 1
     0 0 0 0];
target = [0 0 0 0
          1 0 0 0
          0 1 1 0
          0 0 0 1]; 
y = zeros(4,4);
loss = 0;
for t = 1:4
    vec = [h; x(:,t)];
    f = logsig(Wf*vec + bf);
    i = logsig(Wi*vec + bi);
    C_tild = tanh(Wc*vec + bc);
    C = f.*C + i.*C_tild;
    o = logsig(Wo*vec + bo);
    h = o.*tanh(C);    
    y(:,t) = softmax(Why*h + by);
    loss = loss + sum(-log2(y(:,t)) .* target(:,t));    
end
loss
