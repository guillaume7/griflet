#ifndef PROG_CDF_H
#define PROG_CDF_H

/******************************************************************************************/

//TEST_1_DEPTH_ON/OFF sets to test the program for one depth or for all!!.
#define TEST_1_DEPTH_OFF 

/******************************************************************************************/

#define MAX_NAME_LENGTH 20 //Espace alloue pour garder les valeurs des noms des vars.

#define CDF_ERROR if(status!=NC_NOERR){fprintf(stderr,"%s\n",nc_strerror(status));exit(-1);}
#define H(s) status=s;CDF_ERROR //Macro basique pour les commandes netcdf nc_x

#define WRITE 0
#define READ 1

#define LAND 0
#define WATER 1

typedef short int byte_t;

/******************************************************************************************/

typedef struct nc_file{
	char name_p[MAX_NAME_LENGTH];
	int ncid;
	int ndims; 
	int nvars;
	int ngatts;
	int unlimdimip;
}s_nc_file;

typedef struct nc_attribute{
	int *file_id_p;
	int *var_id_p;
	int num;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	size_t length;
}s_nc_attribute;

typedef struct nc_dimension{ //c'est aussi une variable.
	int *file_id_p;
	int id;
	int varid;
	int ndims;
	int natts;
	nc_type type;
	char name_p[MAX_NAME_LENGTH];
	int dimshape_p[1]; 
	size_t length;  
	s_nc_attribute axis;
	s_nc_attribute units;
}s_nc_dimension;

typedef struct nc_variable_txyz{
	int *file_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	int ndims;
	int natts;
	int dimshape_p[4]; //apeine t,z,y,x.
	int* t_id_p;
	int* z_id_p;
	int* y_id_p;
	int* x_id_p;
	s_nc_attribute missing;
	s_nc_attribute fill;
	s_nc_attribute units;
}s_nc_variable_txyz;

typedef struct nc_variable_xyz{
	int *file_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	int ndims;
	int natts;
	int dimshape_p[3]; //apeine z,y,x.
	int* z_id_p;
	int* y_id_p;
	int* x_id_p;
	s_nc_attribute missing;
	s_nc_attribute fill;
	s_nc_attribute units;
}s_nc_variable_xyz;

typedef struct nc_variable_xy{
	int *file_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	int ndims;
	int natts;
	int dimshape_p[2]; //apeine y,x.
	int* x_id_p;
	int* y_id_p;
	s_nc_attribute missing;
	s_nc_attribute fill;
	s_nc_attribute units;
}s_nc_variable_xy;

typedef struct nc_input_t{
	s_nc_file file;
	s_nc_variable_xy r;
	s_nc_dimension x;
	s_nc_dimension y;
}s_nc_input_t;

typedef struct nc_input_d{
	s_nc_file file;
	s_nc_variable_txyz var;
	s_nc_dimension x;
	s_nc_dimension y;
	s_nc_dimension y_edges;
	s_nc_dimension z;
	s_nc_dimension z_edges;
	s_nc_dimension date;
}s_nc_input_d;

typedef struct nc_result{
	s_nc_file file;
	s_nc_variable_xyz m;
	s_nc_dimension x;
	s_nc_dimension y;
	s_nc_dimension y_edges;
	s_nc_dimension z;
	s_nc_dimension z_edges;
}s_nc_result;

/******************************************************************************************/

//creates the nc_file structure of the topo source
//opens the topo source nc_file, ready for reading...
void set_topo(s_nc_input_t*);

//creates the nc_file structure of the dims source
//opens the dims source nc_file, ready for reading...
void set_dims(s_nc_input_d*);

//creates the cdf_file structure of the target
//creates the target cdf_file; ready for writing...
void set_mask(s_nc_result*, s_nc_input_d*);

//creates the nc_file structure of the topo source
void fill_topo_file_s(s_nc_file*);

//creates the nc_file structure of the dims source
void fill_dims_s(s_nc_input_d*);

//creates the cdf_file structure of the target
void fill_mask_s(s_nc_input_t*);

//Copies the dims (and respective vars) from the dims source to the target.
void copy_dims(s_nc_input_d*, s_nc_result*);
	
//By comparing the topo source's data, writes the topo in the target.
//void write_topo(s_nc_input_t*, s_nc_result*);

//close the target file.
void close(s_nc_result*, s_nc_input_d*, s_nc_input_t*);

/******************************************************************************************/

void new_file_s(s_nc_file*, char*);
void fill_file_s(s_nc_file*, char*, byte_t);
void fill_dim_s(s_nc_dimension*, char*);
void fill_att_s(s_nc_attribute*, char*);
void put_fill_att_short(s_nc_attribute*);
void fill_var_xy_s(s_nc_variable_xy*, char*);
void fill_var_xyz_s(s_nc_variable_xyz*, char*);
void fill_var_txyz_s(s_nc_variable_txyz*, char*);

/******************************************************************************************/

void build_attribute(s_nc_attribute*, int*, int*);
void build_dimension(s_nc_dimension*, s_nc_file*);
void build_variable_txyz(s_nc_variable_txyz*, s_nc_file*, int*, int*, int*, int*);
void build_variable_xyz(s_nc_variable_xyz*, s_nc_file*, int*, int*, int*);
void build_variable_xy(s_nc_variable_xy*, s_nc_file*, int*, int*);

void build_input_t(s_nc_input_t*);
void build_input_d(s_nc_input_d*);
void build_result(s_nc_result*);

/******************************************************************************************/

void inq_file_s( s_nc_file*);
void inq_dim( s_nc_dimension*);
void inq_var_xy( s_nc_variable_xy*);
void inq_var_xyz( s_nc_variable_xyz*);
void inq_var_txyz( s_nc_variable_txyz*);
void inq_att( s_nc_attribute*);

/******************************************************************************************/

void copy_dim( s_nc_dimension*, s_nc_dimension*);
void copy_var_xy( s_nc_variable_xy*, s_nc_variable_xy*);
void copy_var_xyz( s_nc_variable_xyz*, s_nc_variable_xyz*);
void copy_var_txyz( s_nc_variable_txyz*, s_nc_variable_txyz*);
void copy_att( s_nc_attribute*, s_nc_attribute*);

/******************************************************************************************/

void copy_data(s_nc_input_d*, s_nc_result*);
void copy_single_data(s_nc_dimension*, s_nc_dimension*);

/******************************************************************************************/

#endif