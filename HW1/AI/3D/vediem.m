function abc = vediem(u)
z = size(u);
for i=1:z(1,2)
    if u(5,i) == 1
        plot3(u(1,i),u(2,i),u(3,i),'ro','linewidth',2);
    end
    if u(5,i) == -1
    plot3(u(1,i),u(2,i),u(3,i),'g*','linewidth',2);
    end
end
end
    