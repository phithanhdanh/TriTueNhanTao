clc;
clear;
syms f(x) 
f(x) = 1/(1+exp(-x));
u = 1;
b = zeros(1,9);
w = ones(1,24);

in = [1 0];
target = [1 0 0];
out = zeros(1,3);

E = forwardcalc(w,in,target,b,f);
dw = 1E-001;
w = backwardcalc(w,u,E,dw,in,target,b,f);
display(w(1)); display(w(7)); display(w(16));

function w = backwardcalc(w,u,E,dw,in,target,b,f)
w_new = w;
for i=1:length(w)
    w_tmp = w; w_tmp(i) = w(i)+dw;
    w_new(i) =  w(i) - u*(forwardcalc(w_tmp,in,target,b,f)-E)/dw;
end
w = w_new;
end

function E = forwardcalc(w,i,target,b,f)
neth = zeros(1,6);
outh = zeros(1,6);
neto = zeros(1,3);
outo = zeros(1,3);
neth(1) = w(1)*i(1) + w(4)*i(2) + b(1);                             outh(1) = subs(f,neth(1));
neth(2) = w(2)*i(1) + w(5)*i(2) + b(2);                             outh(2) = subs(f,neth(2));
neth(3) = w(3)*i(1) + w(6)*i(2) + b(3);                             outh(3) = subs(f,neth(3));
neth(4) = w(7)*outh(1) + w(10)*outh(2) + w(13)*outh(3) + b(4);      outh(4) = subs(f,neth(4));
neth(5) = w(8)*outh(1) + w(11)*outh(2) + w(14)*outh(3) + b(5);      outh(5) = subs(f,neth(5));
neth(6) = w(9)*outh(1) + w(12)*outh(2) + w(15)*outh(3) + b(6);      outh(6) = subs(f,neth(6));
neto(1) = w(16)*outh(4) + w(19)* outh(5) + w(22)*outh(6) + b(7);    outo(1) = subs(f,neto(1));
neto(2) = w(17)*outh(4) + w(20)* outh(5) + w(23)*outh(6) + b(8);    outo(2) = subs(f,neto(2));
neto(3) = w(18)*outh(4) + w(21)* outh(5) + w(24)*outh(6) + b(9);    outo(3) = subs(f,neto(3));
E = 1/2*((target(1)-outo(1))^2 + (target(2)-outo(2))^2 + (target(3)-outo(3))^2);
end