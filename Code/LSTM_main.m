clear
clc

para = ga(@LSTM_cost,112);
y = LSTM_test(para) %#ok<NOPTS>