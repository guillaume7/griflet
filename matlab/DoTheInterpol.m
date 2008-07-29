importManelaData
importMohidGrids

disp 'Interpolating the salt'
MJ_salt = interp3(lat3D, depth3D, lon3D, salt, mlat3D, mdepth3D, mlon3D);
MJ_salt_2 = invertdimensions(MJ_salt);

disp 'Interpolating the temperature'
MJ_temp = interp3(lat3D, depth3D, lon3D, temp, mlat3D, mdepth3D, mlon3D);
MJ_temp_2 = invertdimensions(MJ_temp);

disp 'Interpolating the Ug'
MJ_Ug = interp3(lat3D, depth3D, lon3D, Ug, mlat3D, mdepth3D, mlon3D);
MJ_Ug_2 = invertdimensions(MJ_Ug);

disp 'Interpolating the Vg'
MJ_Vg = interp3(lat3D, depth3D, lon3D, Vg, mlat3D, mdepth3D, mlon3D);
MJ_Vg_2 = invertdimensions(MJ_Vg);

disp 'Interpolating the dynamic height'
MJ_ad = interp3(lat3D, depth3D, lon3D, ad, mlat3D, mdepth3D, mlon3D);
MJ_ad_2 = invertdimensions(MJ_ad);

%grid
mdepth3D_2 = invertdimensions(mdepth3D);
mlat3D_2 = invertdimensions(mlat3D);
mlon3D_2 = invertdimensions(mlon3D);
