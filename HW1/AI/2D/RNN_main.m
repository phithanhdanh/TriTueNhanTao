clear
clc

para = ga(@RNN_cost2,40);
y = RNN_test(para) %#ok<NOPTS>