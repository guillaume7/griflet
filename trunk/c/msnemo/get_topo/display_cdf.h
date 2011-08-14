#ifndef DISPLAY_CDF_H
#define DISPLAY_CDF_H

//Displays the structure data to a file and on the screen.
void display_nc_structs(s_nc_input_t* , s_nc_input_d*, s_nc_result*);

void display_topo(FILE*, s_nc_input_t*);
void display_dims(FILE*, s_nc_input_d*);
void display_mask(FILE*, s_nc_result*);

void display_file_struct(FILE*, s_nc_file*);
void display_dim_struct(FILE*, s_nc_dimension*);
void display_var_txyz_struct(FILE*, s_nc_variable_txyz*);
void display_var_xyz_struct(FILE*, s_nc_variable_xyz*);
void display_var_xy_struct(FILE*, s_nc_variable_xy*);

#endif