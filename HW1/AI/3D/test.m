
u=[  27     9   -69    -3;
   -81    92    95    60;
   -45    93    92   -72;
     1     1     1     1;
     0     1     0     1];
 z =size(u);
 for i=1:z(1,2)
    if u(5,i) == 1
        plot3(u(1,i),u(2,i),u(3,i),'ro','linewidth',2);
    end
    if u(5,i) == 0
    plot3(u(1,i),u(2,i),u(3,i),'g*','linewidth',2);
    end
 end