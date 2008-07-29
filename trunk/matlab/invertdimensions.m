function inverted = invertdimensions(data)
%function inverted = invertdimensions(data)

siz=size(data);

%inverted order of the input dimensions matrix
inverted = zeros( [ siz(1) siz(3) siz(2) ]);

for a = 1:siz(1)
for b = 1:siz(2)
for c = 1:siz(3)
    
    inverted(a, c, b) = data( a, b, c);
    
end
end
end