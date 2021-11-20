clc
U= taodl(-100,100,50,50);
w =[ 1 1 1 1 0;
    0 0 0 0 1];
dem =0;
while dk(w,U) == 0
    Y=w*U;
    for i=1:length(Y)
        if sign(Y(2,i)*Y(1,i))<=0
             w(1,1) =w(1,1) + Y(2,i)*U(1,i);
             w(1,2) = w(1,2) + Y(2,i)*U(2,i);
             w(1,3) = w(1,3) + Y(2,i)*U(3,i) ;
             w(1,4) = w(1,4) + Y(2,i)*U(4,i);
             dem = dem+1;
         end
  
 vemp(w);
 hold on;
 vediem(U);
 grid on;
 rotate3d on ;
 pause(0.01);
 xlabel(dem);
 hold off;
end
end