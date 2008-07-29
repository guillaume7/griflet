function Acut = DoXYCut(data3D, layer)
%function Acut = DoXYCut(data3D, layer)

siz=size(data);

Acut = zeros([siz(2) siz(3)]);

for a = 1:siz(2)
for b = 1:siz(3)
    
    Acut(a,b) = data(layer, a, b);
    
end
end
