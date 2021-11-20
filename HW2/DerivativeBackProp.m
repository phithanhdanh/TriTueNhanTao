clc;
clear;
syms f(x) 
f(x) = 1/(1+exp(-x));
u = 1;
%w = ones(1,24);
%net = zeros(1,9);
%out = zeros(1,9);
%in = zeros(1,2);

syms i [1 2]
syms w w_new [1 24]
syms neth outh [1 6]
syms neto outo [1 3]
b = zeros(1,9);
target = zeros(1,3);

neth(1) = w(1)*i(1) + w(4)*i(2) + b(1);               outh(1) = f(neth(1));
neth(2) = w(2)*i(1) + w(5)*i(2) + b(2);               outh(2) = f(neth(2));
neth(3) = w(3)*i(1) + w(6)*i(2) + b(3);               outh(3) = f(neth(3));
neth(4) = w(7)*outh(1) + w(10)*outh(2) + w(13)*outh(3) + b(4);      outh(4) = f(neth(4));
neth(5) = w(8)*outh(1) + w(11)*outh(2) + w(14)*outh(3) + b(5);      outh(5) = f(neth(5));
neth(6) = w(9)*outh(1) + w(12)*outh(2) + w(15)*outh(3) + b(6);      outh(6) = f(neth(6));
neto(1) = w(16)*outh(4) + w(19)*outh(5) + w(22)*outh(6) + b(7);     outo(1) = f(neto(1));
neto(2) = w(17)*outh(4) + w(20)*outh(5) + w(23)*outh(6) + b(8);     outo(2) = f(neto(2));
neto(3) = w(18)*outh(4) + w(21)*outh(5) + w(24)*outh(6) + b(9);     outo(3) = f(neto(3));

E = 1/2*((target(1)-outo(1))^2 + (target(2)-outo(2))^2 + (target(3)-outo(3))^2);
i = [0 0];
w = ones(1,24);
for j=1:24
w_new(j) = w(j)-u*diff(E,w(j));
end
k = symvar(w_new(16))
subs(diff(E,w(16)))
symvar(ans)
%display(subs(w_new(16),i,[0; 0]));

