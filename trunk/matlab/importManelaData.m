depth=load('niveis.dat');
lat = load('latitude.dat');
lon = load('longitude.dat');

%Temperature
temp = importManelaVar('Temperatura_anual.dat');

%Salinity
salt = importManelaVar('salinidade_anual.dat');

%Geostrophic U
Ug = importManelaVar('Ug_anual.dat');

%Geostrophic V
Vg = importManelaVar('Vg_anual.dat');

%Dynamic height
ad = importManelaVar('ad_anual.dat');

%Create the 3D coordinates
lat3D = zeros(85,217,229);
for k = 1:85
    lat3D(k,:,:) = lat(:,:);
end

lon3D = zeros(85,217,229);
for k = 1:85
    lon3D(k,:,:) = lon(:,:);
end

depth3D = zeros(85,217,229);
for i = 1:217
    for j = 1:229
        depth3D(:,i,j) = depth(:);
    end
end