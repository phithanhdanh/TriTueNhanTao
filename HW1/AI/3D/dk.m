function a = dk(w,u)
a =1;
y =w*u;
for i=1:length(y)-1
if sign(y(1,i)) ~= sign(y(1,i+1)) 
    if y(2,i) == y(2,i+1)
        a = 0 ;
        break;
    end
end
if sign(y(1,i)) == sign(y(1,i+1)) 
 if y(2,i) ~= y(2,i+1)
     a = 0;
     break;
 end
end
end
end