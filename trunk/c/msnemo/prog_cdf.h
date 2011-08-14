#ifndef PROG_CDF_H
#define PROG_CDF_H

//******indexes pour les Cdimshapeb KEZAKO?****************************
//Ca sert pour aller chercher les INPUTS .cdf
#define NDDIM 1 //nombre de dimensions pour une variable-dimension.
#define NVIDIM 4 //nombre de dimensions pour une variable vitesse cdf de input.
#define I_TIME 0
#define I_DEPTH 1
#define I_LON 3
#define I_LAT 2
//*********************************************************************

#ifdef BLOC_DIM_2D /////////////////////////////////////////////////////////
//******indexes pour les Cdimshapeb KEZAKO?****************************
//Ca sert pour ecrire la concentration dans le out.cdf 
#define	NVDIM 3 //nombre de dimensions pour une variable type concentration.
#define O_TIME 0
#define O_LON 2
#define O_LAT 1
//************************************************************

//******indexes pour les Udimshape KEZAKO?****************************
//Ca sert pour ecrire les vitesses, les frontieres et la source dans le out.cdf
#define NUDIM 2 //nombre de dimensions pour une variable type vitesse.
#define U_LON 0
#define U_LAT 1
//************************************************************
#endif ///////////////////////////////////////////////////////////////////////

#ifdef BLOC_DIM_3D /////////////////////////////////////////////////////////
//******indexes pour les Cdimshapeb KEZAKO?****************************
//Ca sert pour ecrire la concentration dans le out.cdf 
#define	NVDIM 4 //nombre de dimensions pour une variable type concentration.
#define O_TIME 0
#define O_DEPTH 1
#define O_LON 3
#define O_LAT 2
//**********************************************************************

//******indexes pour les Udimshape KEZAKO?****************************
//Ca sert pour ecrire les vitesses, les frontieres et la source dans le out.cdf
#define NUDIM 3 //nombre de dimensions pour une variable type vitesse.
#define U_DEPTH 0
#define U_LON 1
#define U_LAT 2
//***********************************************************************
#endif ///////////////////////////////////////////////////////////////////////

#define MAX_NAME_LENGTH 20 //Espace alloue pour garder les valeurs des noms des vars.

#define CDF_ERROR if(status!=NC_NOERR){fprintf(stderr,"%s\n",nc_strerror(status));exit(-1);}
#define H(s) status=s;CDF_ERROR //Macro basique pour les commandes netcdf nc_x

typedef struct nc_dimensions_offsets{
	size_t lon_p[NDDIM];
	size_t lat_p[NDDIM];
	size_t depth_p[NDDIM];
	size_t date_p[NDDIM];
}s_nc_dimensions_offsets;

typedef struct nc_file{
	char *name_p;
	int ncid;
	int ndims; 
	int nvars;
	int ngatts;
	int unlimdimip;
}s_nc_file;

typedef struct nc_attribute{
	int *file_id_p;
	int *var_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	size_t length;
}s_nc_attribute;

typedef struct nc_dimension{
	int *file_id_p;
	int id;
	int varid;
	int ndims;
	int natts;
	nc_type type;
	char name_p[MAX_NAME_LENGTH];
	int dimshape_p[NDDIM]; //Kezako?
	size_t length;  //Ici ce qu'il y a en plus pour les dimensions.
	s_nc_attribute axis;
	s_nc_attribute units;
	s_nc_attribute modulo; //X only.
	s_nc_attribute origin; //time only.
}s_nc_dimension;

typedef struct nc_variable_txyz{
	int *file_id_p;
	int *t_id_p;
	int *x_id_p;
	int *y_id_p;
	int *z_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	int ndims;
	int natts;
	int dimshape_p[NVDIM]; //avec t,z,y,x
	s_nc_attribute missing;
	s_nc_attribute fill;
	s_nc_attribute units;
}s_nc_variable_txyz;

typedef struct nc_variable_xyz{
	int *file_id_p;
	int *x_id_p;
	int *y_id_p;
	int *z_id_p;
	int id;
	char name_p[MAX_NAME_LENGTH];
	nc_type type;
	int ndims;
	int natts;
	int dimshape_p[NUDIM]; //apeine z,y,x.
	s_nc_attribute missing;
	s_nc_attribute fill;
	s_nc_attribute units;
}s_nc_variable_xyz;

typedef struct nc_input{
	s_nc_file file;
	s_nc_variable_txyz var;
	s_nc_dimension x;
	s_nc_dimension y;
	s_nc_dimension y_edges;
	s_nc_dimension z;
	s_nc_dimension z_edges;
	s_nc_dimension date;
}s_nc_input;

typedef struct nc_input_t{
	s_nc_file file;
	s_nc_variable_xyz var;
	s_nc_dimension x;
	s_nc_dimension y;
	s_nc_dimension y_edges;
	s_nc_dimension z;
	s_nc_dimension z_edges;
}s_nc_input_t;

typedef struct nc_result{
	s_nc_file file;
	s_nc_variable_txyz c;
	s_nc_variable_xyz u;
	s_nc_variable_xyz v;
	s_nc_variable_xyz w;
	s_nc_variable_xyz fr;
	s_nc_variable_xyz so;
	s_nc_dimension x;
	s_nc_dimension y;
	s_nc_dimension z;
	s_nc_dimension time;
}s_nc_result;

typedef struct nc_all_files{
	s_nc_result out;
	s_nc_input u;
	s_nc_input v;
	s_nc_input w;
	s_nc_input_t topo;
}s_nc_all_files;

void nccourant_init(s_nc_input*);
void ncedges_init(s_nc_all_files *);
void ncfiles_init(s_nc_all_files*);
void ncfiles_close(s_nc_all_files*);
void nctopo_init(s_nc_input_t*);

/******************************************************************************************/

void fill_dim_s(s_nc_dimension*, char*);
void fill_att_s(s_nc_attribute*, char*);
void fill_var_xyz_s(s_nc_variable_xyz*, char*);
void fill_var_txyz_s(s_nc_variable_txyz*, char*);

/******************************************************************************************/

void build_attribute(s_nc_attribute*, int*, int*);
void build_dimension(s_nc_dimension*, s_nc_file*);
void build_variable_txyz(s_nc_variable_txyz*, s_nc_file*, int*, int*, int*, int*);
void build_variable_xyz(s_nc_variable_xyz*, s_nc_file*, int*, int*, int*);

void build_input_t(s_nc_input_t*);

/******************************************************************************************/

void inq_file_s( s_nc_file*);
void inq_dim( s_nc_dimension*);
void inq_var_xyz( s_nc_variable_xyz*);
void inq_var_txyz( s_nc_variable_txyz*);
void inq_att( s_nc_attribute*);

/******************************************************************************************/

#endif