function dau = xet(u,w)
U=w*u;
dau =1 ;
   for i=1:length(U)-1
       if sign(U(1,i)) ~= sign(U(1,i+1)) && U(2,i)== U(2,i+1)
           dau = 0;
           break;
       end
   end
 end