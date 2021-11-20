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
dem = 0;
while xet(U,w) == 0 
     a =w*U;
     for i=1:length(a)
         if  a(1,i)*a(2,i) <= 0
             w(1,1) =w(1,1) + a(2,i)*U(1,i);
             w(1,2) = w(1,2) + a(2,i)*U(2,i);
             w(1,3) = w(1,3) + a(2,i)*U(3,i) ;
             dem = dem+1;
         end
     end
    x =-100:1:100;
    y = (-w(1,1)*x-w(1,3))/w(1,2); 
    plot(x,y,'r');
    hold on
   plot_dl(U);
   xlabel(dem);
   xlabel(dem);
   hold off
   pause(0.1);
end  
 