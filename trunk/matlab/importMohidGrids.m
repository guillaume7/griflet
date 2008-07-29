%import the mohid netcdf grid coordinates
file='20060601_Portugal_WaterProperties_1.nc';
mlat = nc_varget(file, 'lat');
mlon = nc_varget(file, 'lon');
mdepth = nc_varget(file, 'depth');

mlat3D = zeros(43,177,117);
for k = 1:43
    for j = 1:117
        mlat3D(k,:,j) = mlat(:);
    end
end

mlon3D = zeros(43,177,117);
for k = 1:43
    for i = 1:177
        mlon3D(k,i,:) = mlon(:);
    end
end

mdepth3D = zeros(43,177,117);
for i = 1:177
    for j = 1:117
        mdepth3D(:,i,j) = mdepth(:);
    end
end
