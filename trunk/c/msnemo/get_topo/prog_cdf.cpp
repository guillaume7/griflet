#include "stdafx.h"

///////////////////////////////////////////////////////////////////////////////////////////
//create and open functions________________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/******************************************************************************************/
//creates the nc_file structure of the topo source
//opens the topo source nc_file, ready for reading...
void set_topo(s_nc_input_t *topo){
/******************************************************************************************/
	fill_file_s(&(topo->file), "earth_topo.nc", READ);

	fill_var_xy_s(&(topo->r), "ROSE");
	fill_att_s(&(topo->r.missing), "missing_value");
	fill_att_s(&(topo->r.fill), "_FillValue");
	fill_att_s(&(topo->r.units), "units");

	fill_dim_s(&(topo->x),"ETOPO05_X");
	fill_att_s(&(topo->x.axis), "axis");
	fill_att_s(&(topo->x.units), "units");

	fill_dim_s(&(topo->y),"ETOPO05_Y1_2160");
	fill_att_s(&(topo->y.axis), "axis");
	fill_att_s(&(topo->y.units), "units");

	return;
}

/******************************************************************************************/
//creates the nc_file structure of the dims source
//opens the dims source nc_file, ready for reading...
void set_dims(s_nc_input_d *dims){
/******************************************************************************************/
	fill_file_s(&(dims->file), "96_u.cdf", READ);

	fill_var_txyz_s(&(dims->var), "U");
	fill_att_s(&(dims->var.missing), "missing_value");
	fill_att_s(&(dims->var.fill), "_FillValue");
	fill_att_s(&(dims->var.missing), "units");

	fill_dim_s(&(dims->date), "TIME1");
	fill_att_s(&(dims->date.axis), "axis");
	fill_att_s(&(dims->date.units), "units");

	fill_dim_s(&(dims->x), "XU_I180_540");
	fill_att_s(&(dims->x.axis), "axis");
	fill_att_s(&(dims->x.units), "units");
	
	fill_dim_s(&(dims->y), "YU_J1_199");
	fill_att_s(&(dims->y.axis), "axis");
	fill_att_s(&(dims->y.units), "units");
	
	fill_dim_s(&(dims->y_edges), "YU_J1_199edges");
	
	fill_dim_s(&(dims->z), "ZT_K1_30");
	fill_att_s(&(dims->z.axis), "axis");
	fill_att_s(&(dims->z.units), "units");
	
	fill_dim_s(&(dims->z_edges), "ZT_K1_30edges");
	
	return;
}

/******************************************************************************************/
//creates the target cdf_file; defines the dims (copied from the 98_u.cdf) and the vars.
//creates the cdf_file structure of the target; ready for writing...
void set_mask(s_nc_result *mask, s_nc_input_d *dims){
/*****************************************************************************************/
	int status;
	int dimshape[3];

	//CREATE A NEW .cdf FILE
	new_file_s(&(mask->file), "topo.cdf");

	//DEFINE DIMENSIONS
	copy_dim(&(mask->x), &(dims->x));
	copy_att(&(mask->x.axis),&(dims->x.axis));
	copy_att(&(mask->x.units),&(dims->x.units));

	copy_dim(&(mask->y), &(dims->y));
	copy_att(&(mask->y.axis),&(dims->y.axis));
	copy_att(&(mask->y.units),&(dims->y.units));

	copy_dim(&(mask->y_edges), &(dims->y_edges));
	
	copy_dim(&(mask->z), &(dims->z));
	copy_att(&(mask->z.axis),&(dims->z.axis));
	copy_att(&(mask->z.units),&(dims->z.units));

	copy_dim(&(mask->z_edges), &(dims->z_edges));

	//DEFINE VARIABLE
	dimshape[0] = mask->z.id;
	dimshape[1] = mask->y.id;
	dimshape[2] = mask->x.id;
	status = nc_def_var(mask->file.ncid, "LANDMASK", NC_SHORT, 3, dimshape, &(mask->m.id));
	CDF_ERROR

	//DEFINE VAR ATTRIBUTES (filling and missing value only)

	put_fill_att_short(&(mask->m.fill));
	copy_att(&(mask->m.missing), &(dims->var.missing));

	//LEAVE DEF MODE
	status = nc_enddef(mask->file.ncid);
	CDF_ERROR

	//FILL STRUCTURE (ici, faire inq_dim et inq_var)
	inq_file_s(&(mask->file));

	inq_var_xyz(&(mask->m));
	inq_att(&(mask->m.fill));
	inq_att(&(mask->m.missing));

	inq_dim(&(mask->x));
	inq_att(&(mask->x.axis));
	inq_att(&(mask->x.units));

	inq_dim(&(mask->y));
	inq_att(&(mask->y.axis));
	inq_att(&(mask->y.units));

	inq_dim(&(mask->y_edges));

	inq_dim(&(mask->z));
	inq_att(&(mask->z.axis));
	inq_att(&(mask->z.units));

	inq_dim(&(mask->z_edges));

	return;
}
/********************************************************************************************/

/*****************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//Construct the nc structures______________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

void build_attribute(s_nc_attribute* att_p, int* fid_p, int* vid_p){
	att_p->file_id_p = fid_p;
	att_p->var_id_p = vid_p;
	return;
}

void build_dimension(s_nc_dimension* d_p, s_nc_file* f_p){
	d_p->file_id_p = &(f_p->ncid);
	build_attribute( &(d_p->axis), d_p->file_id_p, &(d_p->varid));
	build_attribute( &(d_p->units),d_p->file_id_p, &(d_p->varid));
	return;
}

void build_variable_txyz(s_nc_variable_txyz* v_p, s_nc_file* f_p, int* t_p, int* x_p, int* y_p, int* z_p){
	v_p->file_id_p = &(f_p->ncid);
	v_p->t_id_p = t_p;
	v_p->x_id_p = x_p;
	v_p->y_id_p = y_p;
	v_p->z_id_p = z_p;
	build_attribute( &(v_p->missing), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->fill), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->units), v_p->file_id_p, &(v_p->id));
	return;
}

void build_variable_xyz(s_nc_variable_xyz* v_p, s_nc_file* f_p, int* x_p, int* y_p, int* z_p){
	v_p->file_id_p = &(f_p->ncid);
	v_p->x_id_p = x_p;
	v_p->y_id_p = y_p;
	v_p->z_id_p = z_p;
	build_attribute( &(v_p->missing), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->fill), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->units), v_p->file_id_p, &(v_p->id));
	return;
}

void build_variable_xy(s_nc_variable_xy* v_p, s_nc_file* f_p, int* x_p, int* y_p){
	v_p->file_id_p = &(f_p->ncid);
	v_p->x_id_p = x_p;
	v_p->y_id_p = y_p;
	build_attribute( &(v_p->missing), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->fill), v_p->file_id_p, &(v_p->id));
	build_attribute( &(v_p->units), v_p->file_id_p, &(v_p->id));
	return;
}

void build_input_t(s_nc_input_t* topo){
	build_variable_xy( &(topo->r), &(topo->file), &(topo->x.id), &(topo->y.id));
	build_dimension( &(topo->x), &(topo->file));
	build_dimension( &(topo->y), &(topo->file));
	return;
}

void build_input_d(s_nc_input_d* dims){
	build_variable_txyz( &(dims->var), &(dims->file), &(dims->date.id), &(dims->x.id), &(dims->y.id), &(dims->z.id));
	build_dimension( &(dims->date), &(dims->file));
	build_dimension( &(dims->x), &(dims->file));
	build_dimension( &(dims->y), &(dims->file));
	build_dimension( &(dims->z), &(dims->file));
	build_dimension( &(dims->y_edges), &(dims->file));
	build_dimension( &(dims->z_edges), &(dims->file));
	return;
}

void build_result( s_nc_result* mask){
	build_variable_xyz( &(mask->m), &(mask->file), &(mask->x.id), &(mask->y.id), &(mask->z.id));
	build_dimension( &(mask->x), &(mask->file));
	build_dimension( &(mask->y), &(mask->file));
	build_dimension( &(mask->z), &(mask->file));
	build_dimension( &(mask->y_edges), &(mask->file));
	build_dimension( &(mask->z_edges), &(mask->file));
	return;
}
/********************************************************************************************/

/********************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//create the nc structures________________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/******************************************************************************************/
//creates a new nc_file 
void new_file_s(s_nc_file* f_p, char* str_p){
/******************************************************************************************/
	int status;

	//CREATE FILE
	strcpy(f_p->name_p, str_p);
	status = nc_create(f_p->name_p, NC_CLOBBER, &(f_p->ncid));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_file structure
void fill_file_s(s_nc_file* f_p, char* str_p, byte_t n){
/******************************************************************************************/
	int status;

	//OPEN
	strcpy(f_p->name_p, str_p);
	if(n==READ) status = nc_open(f_p->name_p,NC_NOWRITE, &(f_p->ncid));
	else status = nc_open(f_p->name_p,NC_WRITE, &(f_p->ncid));
	CDF_ERROR

	//INQ_FILE
	inq_file_s(f_p);

	return;
}

/******************************************************************************************/
//creates the nc_dim structure
void fill_dim_s(s_nc_dimension* d_p, char* str_p){
/******************************************************************************************/
	int status;

	//INQ_DIM_ID
	status = nc_inq_dimid( *(d_p->file_id_p), str_p, &(d_p->id) );
	CDF_ERROR

	//INQ_VARID
	status = nc_inq_varid( *(d_p->file_id_p), str_p, &(d_p->varid) );
	CDF_ERROR

	//INQ_DIM
	inq_dim(d_p);

	return;
}

/******************************************************************************************/
//creates the nc_var_xy structure
void fill_var_xy_s(s_nc_variable_xy* v_p, char* str_p){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), str_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	inq_var_xy(v_p);

	return;
}

/******************************************************************************************/
//creates the nc_var_xyz structure
void fill_var_xyz_s(s_nc_variable_xyz* v_p, char* str_p){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), str_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	inq_var_xyz(v_p);

	return;
}

/******************************************************************************************/
//creates the nc_var_txyz structure
void fill_var_txyz_s(s_nc_variable_txyz* v_p, char* str_p){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), str_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	inq_var_txyz(v_p);

	return;
}

/******************************************************************************************/
//creates the nc_dim structure
void fill_att_s(s_nc_attribute* a_p, char* str_p){
/******************************************************************************************/
	int status;

	//INQ_ATT_ID
	strcpy(a_p->name_p, str_p);
	status = nc_inq_attid( *(a_p->file_id_p), *(a_p->var_id_p), a_p->name_p, &(a_p->num));
	CDF_ERROR
	
	//INQ_ATT
	inq_att(a_p);

	return;
}

/******************************************************************************************/
//Creates the fillvalue attribute for short integers
void put_fill_att_short(s_nc_attribute* at_p){
/******************************************************************************************/
	int status;
	byte_t fill;

	fill = -32767;
	strcpy(at_p->name_p, "_FillValue");
	status = nc_put_att_short( *(at_p->file_id_p), *(at_p->var_id_p), at_p->name_p, NC_SHORT, 1, &fill);
	CDF_ERROR

	return;
}

/********************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//Construct the nc copy structures______________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/********************************************************************************************/
//Copies the dimension
void copy_dim( s_nc_dimension *target, s_nc_dimension *source){
/********************************************************************************************/
	int status;

	//DEFINE DIMENSION
	status = nc_def_dim( *(target->file_id_p), source->name_p, source->length, &(target->id));
	CDF_ERROR

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), source->name_p, source->type, 
						source->ndims, &(target->id), &(target->varid));  //Ici, un prob?
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_txyz( s_nc_variable_txyz *target, s_nc_variable_txyz *source){
/********************************************************************************************/
	int status;
	int dimshape[4];

	//DEF VAR INFO
	dimshape[0] = *(target->t_id_p); //time
	dimshape[1] = *(target->z_id_p); //z
	dimshape[2] = *(target->y_id_p); //y
	dimshape[3] = *(target->x_id_p); //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), source->name_p, source->type, 
						source->ndims, dimshape, &(target->id));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_xyz( s_nc_variable_xyz *target, s_nc_variable_xyz *source){
/********************************************************************************************/
	int status;
	int dimshape[3];

	//DEF VAR INFO
	dimshape[0] = *(target->z_id_p); //z
	dimshape[1] = *(target->y_id_p); //y
	dimshape[2] = *(target->x_id_p); //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), source->name_p, source->type, 
						source->ndims, dimshape, &(target->id));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_xy( s_nc_variable_xy *target, s_nc_variable_xy *source){
/********************************************************************************************/
	int status;
	int dimshape[2];

	//DEF VAR INFO
	dimshape[0] = *(target->y_id_p); //y
	dimshape[1] = *(target->x_id_p); //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), source->name_p, source->type, 
						source->ndims, dimshape, &(target->id));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the attribute
void copy_att( s_nc_attribute *target, s_nc_attribute *source){
/********************************************************************************************/
	int status;

	//DEFINE ATTRIBUTE
	strcpy(target->name_p, source->name_p);
	status = nc_copy_att( *(source->file_id_p), *(source->var_id_p), 
						target->name_p, *(target->file_id_p), *(target->var_id_p));
	CDF_ERROR

	return;
}

/********************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//Fill'em with the inq structures__________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/********************************************************************************************/
//Inqs the given file
void inq_file_s( s_nc_file* f_p){
/********************************************************************************************/
	int status;

	//INQ_FILE
	status = nc_inq(f_p->ncid, &(f_p->ndims), &(f_p->nvars),&(f_p->ngatts), &(f_p->unlimdimip));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Inqs the given dimension
void inq_dim( s_nc_dimension* d_p){
/********************************************************************************************/
	int status;

	//INQ_DIM
	status = nc_inq_dim( *(d_p->file_id_p), d_p->id, d_p->name_p, &(d_p->length) );
	CDF_ERROR;

	//INQ_VAR
	status = nc_inq_var( *(d_p->file_id_p), d_p->varid, d_p->name_p, 
						&(d_p->type), &(d_p->ndims), d_p->dimshape_p, &(d_p->natts));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Inqs the given variable
void inq_var_txyz( s_nc_variable_txyz* v_p){
/********************************************************************************************/
	int status;

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR


	return;
}

/********************************************************************************************/
//Inqs the given variable
void inq_var_xyz( s_nc_variable_xyz* v_p){
/********************************************************************************************/
	int status;

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR


	return;
}

/********************************************************************************************/
//Inqs the given variable
void inq_var_xy( s_nc_variable_xy* v_p){
/********************************************************************************************/
	int status;

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR


	return;
}

/********************************************************************************************/
//Inqs the given attribute
void inq_att( s_nc_attribute* a_p){
/********************************************************************************************/
	int status;

	//INQ_ATT
	status = nc_inq_att( *(a_p->file_id_p), *(a_p->var_id_p), a_p->name_p, &(a_p->type), &(a_p->length));
	CDF_ERROR

	return;
}
/********************************************************************************************/

/********************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//Close'em_________________________________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////


/********************************************************************************************/
//close the target files
void close(s_nc_result *mask, s_nc_input_d *dims, s_nc_input_t *topo){
/********************************************************************************************/
	int status;

	//Close the result file
	status = nc_close(mask->file.ncid);
	CDF_ERROR

	//Close the dimensions file
	status = nc_close(dims->file.ncid);
	CDF_ERROR

	//Close the source file
	status = nc_close(topo->file.ncid);
	CDF_ERROR

	return;
}

/********************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////
//Copies'em_________________________________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/***********************************************************************************************/
//Copies the dims (and respective vars) from the dims source to the target.
void copy_data(s_nc_input_d* source_p, s_nc_result* target_p){
/***********************************************************************************************/

	copy_single_data( &(target_p->x), &(source_p->x));
	copy_single_data( &(target_p->y), &(source_p->y));
	copy_single_data( &(target_p->y_edges), &(source_p->y_edges));
	copy_single_data( &(target_p->z), &(source_p->z));
	copy_single_data( &(target_p->z_edges), &(source_p->z_edges));

	return;
}

/***********************************************************************************************/
//Copies the dims (and respective vars) from the dims source to the target.
void copy_single_data(s_nc_dimension* target_p, s_nc_dimension* source_p){
/***********************************************************************************************/
	int status;
	double* temp_p;

	//alloc memory
	temp_p = (double*) malloc(source_p->length*sizeof(double));
	
	//read
	status = nc_get_var_double(*(source_p->file_id_p), source_p->varid, temp_p);
	CDF_ERROR

	//write
	status = nc_put_var_double(*(target_p->file_id_p), target_p->varid, temp_p);
	CDF_ERROR

	//free memory
	free(temp_p);

	return;
}
