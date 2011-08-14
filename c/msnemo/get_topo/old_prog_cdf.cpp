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
	fill_file_s(&(dims->file), "98_u.cdf", READ);

	fill_var_txyz(&(dims->var), "U");
	fill_att_s(&(dims->var.missing, "missing_value"));
	fill_att_s(&(dims->var.fill, "_FillValue"));
	fill_att_s(&(dims->var.missing, "units"));

	fill_dim_s(&(dims->date, "TIME1");
	fill_att_s(&(dims->date.axis, "axis");
	fill_att_s(&(dims->date.units, "units");

	fill_dim_s(&(dims->x, "XU_I180_540");
	fill_att_s(&(dims->x.axis, "axis");
	fill_att_s(&(dims->x.units, "units");
	
	fill_dim_s(&(dims->y, "YU_J1_199");
	fill_att_s(&(dims->y.axis, "axis");
	fill_att_s(&(dims->y.units, "units");
	
	fill_dim_s(&(dims->y_edges, "YU_J1_199edges");
	
	fill_dim_s(&(dims->z, "ZT_K1_30");
	fill_att_s(&(dims->z.axis, "axis");
	fill_att_s(&(dims->z.units, "units");
	
	fill_dim_s(&(dims->z_edges, "ZT_K1_30edges");
	
	return;
}

/******************************************************************************************/
//creates the target cdf_file; defines the dims (copied from the 98_u.cdf) and the vars.
//creates the cdf_file structure of the target
//ready for writing...
void set_mask(s_nc_result *mask, s_nc_input_d *dims){
/*****************************************************************************************/
	int status;
	int* dimshape_p[3];

	//CREATE A NEW .cdf FILE
	new_file_s(&(mask->file), "topo.cdf");

	//DEFINE DIMENSIONS
	copy_dim(&(mask->x), &(dims->x);
	copy_dim(&(mask->y), &(dims->x);
	copy_dim(&(mask->y_edges), &(dims->y_edges);
	copy_dim(&(mask->z), &(dims->z);
	copy_dim(&(mask->z_edges, &(dims->z_edges);

	//DEFINE VARIABLE
	dimshape_p[0] = mask->z.id;
	dimshape_p[1] = mask->y.id;
	dimshape_p[2] = mask->x.id;
	status = nc_def_var(mask->file.ncid, "LANDMASK", NC_BYTE, 3, dimshape_p, &(mask->m.id));
	CDF_ERROR

	return;
}

///////////////////////////////////////////////////////////////////////////////////////////
//create the nc structures________________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/******************************************************************************************/
//creates a new nc_file 
void new_file_s(s_nc_file *f, char *str){
/******************************************************************************************/
	int status;

	//CREATE FILE
	strcpy(f->name_p, str);
	status = nc_create(str, NC_NOCLOBBER, &(f->ncid));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_file structure
void fill_file_s(s_nc_file *f, char *str, byte_t n){
/******************************************************************************************/
	int status;

	//OPEN
	strcpy(f->name_p, str);
	if(n==READ) status = nc_open(f->name_p,NC_NOWRITE, &(f->ncid));
	else status = nc_open(f->name_p,NC_WRITE, &(f->ncid));
	CDF_ERROR

	//INQ_FILE
	status = nc_inq(f->ncid, &(f->ndims), &(f->nvars),&(f->ngatts), &(f->unlimdimip));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_dim structure
void fill_dim_s(s_nc_dimension* d_p, char *str){
/******************************************************************************************/
	int status;

	//INQ_DIM_ID
	strcpy(d_p->name_p, str);
	status = nc_inq_dimid( *(d_p->file_id_p), d_p->name_p, &(d_p->id) );
	CDF_ERROR

	//INQ_DIM
	status = nc_inq_dim( *(d_p->file_id_p), d_p->id, d_p->name_p, &(d_p->length) );
	CDF_ERROR;

	//INQ_VARID
	status = nc_inq_varid( *(d_p->file_id_p), d_p->name_p, &(d_p->varid) );
	CDF_ERROR

	//INQ_VAR
	status = nc_inq_var( *(d_p->file_id_p), d_p->varid, d_p->name_p, 
						&(d_p->type), &(d_p->ndims), d_p->dimshape_p, &(d_p->natts));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_var_xy structure
void fill_var_xy_s(s_nc_variable_xy* v_p, char *str){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), v_p->name_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_var_xyz structure
void fill_var_xyz_s(s_nc_variable_xyz* v_p, char *str){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), v_p->name_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_var_txyz structure
void fill_var_txyz_s(s_nc_variable_txyz* v_p, char *str){
/******************************************************************************************/
	int status;

	//INQ_VARID
	status = nc_inq_varid( *(v_p->file_id_p), v_p->name_p, &(v_p->id) );
	CDF_ERROR

	//INQ_VAR
	status = nc_inq_var( *(v_p->file_id_p), v_p->id, v_p->name_p, 
						&(v_p->type), &(v_p->ndims), v_p->dimshape_p, &(v_p->natts));
	CDF_ERROR

	return;
}

/******************************************************************************************/
//creates the nc_dim structure
void fill_att_s(s_nc_attribute* a_p, char *str){
/******************************************************************************************/
	int status;

	//INQ_ATT_ID
	strcpy(a_p->name_p, str);
	status = nc_inq_attid( *(a_p->file_id_p), *(a_p->var_id_p), a_p->name_p, &(a_p->id) );
	CDF_ERROR

	//INQ_ATT
	status = nc_inq_att( *(a_p->file_id_p), *(a_p->var_id_p), a_p->name_p, &(a_p->type), &(a_p->length));
	CDF_ERROR

	return;
}


/********************************************************************************************/
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
	build_variable_xy( &(topo->r), &(topo->file));
	build_dimension( &(topo->x), &(topo->file));
	build_dimension( &(topo->y), &(topo->file));
	return;
}

void build_input_d(s_nc_input_t* dims){
	build_variable_txyz( &(dims->var), &(dims->file));
	build_dimension( &(dims->date), &(dims->file));
	build_dimension( &(dims->x), &(dims->file));
	build_dimension( &(dims->y), &(dims->file));
	build_dimension( &(dims->z), &(dims->file));
	build_dimension( &(dims->y_edges), &(dims->file));
	build_dimension( &(dims->z_edges), &(dims->file));
	return;
}

void build_result( s_nc_result* mask){
	build_variable_xyz( &(mask->m), &(mask->file));
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
//Construct the nc copy structures______________________________________________________________
///////////////////////////////////////////////////////////////////////////////////////////

/********************************************************************************************/
//Copies the dimension
void copy_dim( s_nc_dimension *target, s_nc_dimension *source){
/********************************************************************************************/
	int status;

	//COPY DIM INFO
	strcpy( target->name_p, source->name_p);
	target->length = source->length;

	//DEFINE DIMENSION
	status = nc_def_dim( *(target->file_id_p), target->name_p, target->length, &(target->id));
	CDF_ERROR

	//COPY VAR INFO
	target->type = source->type;
	target->ndims = source->ndims;
	target->dimshape_p[0] = target->id; 

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), target->name_p, target->type, 
						target->ndims, target->dimshape_p, &(target->varid));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_txyz( s_nc_variable_txyz *target, s_nc_variable_txyz *source){
/********************************************************************************************/
	int status;

	//COPY VAR INFO
	strcpy( target->name_p, source->name_p);
	target->type = source->type;
	target->ndims = source->ndims;
	target->dimshape_p[0] = target->t_id_p; //time
	target->dimshape_p[1] = target->z_id_p; //z
	target->dimshape_p[2] = target->y_id_p; //y
	target->dimshape_p[3] = target->x_id_p; //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), target->name_p, target->type, 
						target->ndims, target->dimshape_p, &(target->id));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_xyz( s_nc_variable_xyz *target, s_nc_variable_xyz *source){
/********************************************************************************************/
	int status;

	//COPY VAR INFO
	strcpy( target->name_p, source->name_p);
	target->type = source->type;
	target->ndims = source->ndims;
	target->dimshape_p[0] = target->z_id_p; //z
	target->dimshape_p[1] = target->y_id_p; //y
	target->dimshape_p[2] = target->x_id_p; //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), target->name_p, target->type, 
						target->ndims, target->dimshape_p, &(target->id));
	CDF_ERROR

	return;
}

/********************************************************************************************/
//Copies the variable
void copy_var_xy( s_nc_variable_xy *target, s_nc_variable_xy *source){
/********************************************************************************************/
	int status;

	//COPY VAR INFO
	strcpy( target->name_p, source->name_p);
	target->type = source->type;
	target->ndims = source->ndims;
	target->dimshape_p[0] = target->y_id_p; //y
	target->dimshape_p[1] = target->x_id_p; //x

	//DEFINE RESPECTIVE VARIABLE
	status = nc_def_var( *(target->file_id_p), target->name_p, target->type, 
						target->ndims, target->dimshape_p, &(target->id));
	CDF_ERROR

	return;
}
