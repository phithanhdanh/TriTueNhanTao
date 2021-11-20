function Y = taodl(min,max,n,m)
syms x y z;
Y = zeros(5,n+m);
a = randi([-10,10],1);
b = randi([-10,10],1);
c = randi([-10,10],1);
d = randi([-10,10],1);

dem=0;
dem1=0;
dem2=0;
while dem <m+n
x = randi([min,max],1);
y = randi([min,max],1);
z  = randi([min,max],1);
f = a*x+b*y+c*z+d;
if f > 10 && dem1<n
 dem=dem+1;
 dem1=dem1+1;
 Y(1,dem) = x;
 Y(2,dem) = y;
 Y(3,dem) = z;
 Y(4,dem) = 1;
 Y(5,dem) = 1;
end
if f < -10 && dem2<m
 dem=dem+1;
 dem2=dem2+1;
 Y(1,dem) = x;
 Y(2,dem) = y;
 Y(3,dem) = z;
 Y(4,dem) = 1;
 Y(5,dem) = -1;
end
end
end