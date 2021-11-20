function  wer = vemp(w)
 [X,Y] = meshgrid([-100:1:100]);
 Z = (-X*w(1,1)-Y*w(1,2)-w(1,4))/w(1,3);
 plot3(X,Y,Z)
 grid on
end