clc
load('dl.mat');
w =[ 1 1 1 0;
     0 0 0 1];
syms x y;
wp = class1;   
lm = class2;
% t?o ma tr?n r?ng U 
U = zeros(4,length(wp)+length(lm));
% ??a d? li?u vào ma tr?n U
for i=1:length(wp)
 U(1,i)=wp(1,i);
 U(2,i)=wp(2,i);
 U(3,i) = 1;
 U(4,i) = 1;
end
for i= length(wp)+1:length(U)
    U(1,i)=lm(1,i-length(wp));
    U(2,i)=lm(2,i-length(wp));
    U(3,i)=1;
    U(4,i)= -1;
end
% T?o m?t ma tr?n w b?t kì d?ng w=[ wx wy w0 0
                             %  0 0 0 1]

 a = w*U;
% gi?i bài toán
while xet(U,w) == 0 
   i = randi(length(U),1,1);
  if sign(a(1,i))~=U(4,i)
      if sign(a(1,i)) ~=0
      w(1,1) =( w(1,1) + U(4,i)*U(1,i))/10;
       w(1,2) = (w(1,2) + U(4,i)*U(2,i))/10;
       w(1,3) =( w(1,3) + U(4,i)*U(3,i))/10;
      end
  end
    x =-100:1:100;
    y = (-w(1,1)*x-w(1,3))/w(1,2); 
    plot(x,y,'r');
     hold on
   plot_dl(U);
   hold off
   pause(0.05)
end  
 