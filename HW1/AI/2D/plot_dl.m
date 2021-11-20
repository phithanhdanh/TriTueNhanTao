function abc =plot_dl(u)
for i=1:length(u)
    if u(4,i)== 1
       plot(u(1,i),u(2,i),'ro');
    end
    if u(4,i)== -1
    plot(u(1,i),u(2,i),'g*');
    end
end
end