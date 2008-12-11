function newmap = invertcolormap(map)
%function invertcolormap(map)

oldmap = colormap(map);
siz = size(oldmap);
newmap = zeros(siz);
for i=1:siz(1)
    newmap(i,:)=oldmap(siz(1)+1-i,:);
end
colormap(newmap);
