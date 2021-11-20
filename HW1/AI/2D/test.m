 w =[ 1 1 1 1 0;
    0 0 0 0 1];
U=taodl(-50,50,5,6);
for i=1:10
    w(1,1)=w(1,1)+i;
vemp(w);
 hold on;
 vediem(U)
 grid on;
 rotate3d on ;
 hold off;
 pause(0.5);
 end