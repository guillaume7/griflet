#ifndef PROG_CDF_OUT_H
#define PROG_CDF_OUT_H

#define MODULO_DEG 360.0

#ifdef BLOC_DIM_3D
#define CDF_BLC v[*k][*i][*j]
#endif

#ifdef BLOC_DIM_2D
#define CDF_BLC v[*i][*j]
#endif

void cdf_new(s_nc_all_files*, s_all_parameters*, s_memory_blocs*);
void cdf_fill_dim(  int, int, s_nc_dimension*, s_nc_dimension*, size_t);
void cdf_fill_time(s_nc_result*, s_all_parameters*);
void cdf_fill_var(int, bloc_t, s_nc_variable_xyz*, s_nc_result*);
void cdf_fill_bvar(int, b_bloc_t, s_nc_variable_xyz*, s_nc_result*);

//Fonction qui ecrit en netcdf mes resultats de concentration.
int cdf_write( bloc_t data, s_all_parameters *, s_nc_result *, index_t);
void cdf_close(s_nc_file*);

#endif