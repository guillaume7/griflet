#include "stdafx.h"

#define BRAKETID(x,id) u->file.ncid, u->x.name_p, &(u->x.id)
#define NC_OPEN nc_open(u->file.name_p,NC_NOWRITE, &(u->file.ncid))
#define NC_CLOSE(s) nc_close(b->s.file.ncid)
#define NC_INQ nc_inq(u->file.ncid, &(u->file.ndims), &(u->file.nvars),&(u->file.ngatts), &(u->file.unlimdimip))
#define NC_INQ_VARID(x,id) nc_inq_varid(BRAKETID(x,id))
#define NC_INQ_VAR(var,id) nc_inq_var(u->file.ncid, u->var.id, u->var.name_p, &(u->var.type), &(u->var.ndims), u->var.dimshape_p, &(u->var.natts))
#define NC_INQ_DIMID(x) nc_inq_dimid(BRAKETID(x,id))
#define NC_INQ_DIM(x)   nc_inq_dim(u->file.ncid, u->x.id, u->x.name_p, &(u->x.length))
#define NC_INQ_ATTID(x,xid,n) nc_inq_attid(u->file.ncid, u->x.xid, u->x.n.name_p, &(u->x.n.id))
#define NC_INQ_ATT(x,xid,n) nc_inq_att(u->file.ncid, u->x.xid, u->x.n.name_p, &(u->x.n.type), &(u->x.n.length))

#define STRING(p,s,v) strcpy(b->p.s.v.name_p,v)
#define STRUNITS(p,s) STRING(p,s,units) 
#define UNITSCPY(s) STRUNITS(u,s);STRUNITS(v,s);STRUNITS(w,s);
#define STRORIG(p,s) STRING(p,s,origin)
#define ORIGCPY STRORIG(u,date);STRORIG(v,date);STRORIG(w,date);
#define STRAXIS(p,s) STRING(p,s,axis) 
#define AXISCPY(s) STRAXIS(u,s);STRAXIS(v,s);STRAXIS(w,s);
#define STRMODULO(p,s) STRING(p,s,modulo)
#define MODULOCPY STRMODULO(u,x);STRMODULO(v,x);STRMODULO(w,x); 
#define STRDATE(s) strcpy(b->s.date.name_p,date)
#define DATECPY STRDATE(u);STRDATE(v);STRDATE(w);
#define STRVAR(p,s) strcpy(b->p.var.s.name_p,s)
#define VARCPY(p) STRVAR(p,missing);STRVAR(p,fill);STRVAR(p,units);strcpy(b->p.var.name_p,p);
#define XUCPY(s) 	strcpy(b->s.x.name_p,xu);strcpy(b->s.y.name_p,yu);strcpy(b->s.z.name_p,zt);
#define XTCPY(s) 	strcpy(b->s.x.name_p,xt);strcpy(b->s.y.name_p,yt);strcpy(b->s.z.name_p,zw);
#define EDGESCPY(s) strcpy(b->s.y_edges.name_p,yt_edges);strcpy(b->s.z_edges.name_p,zt_edges);

//*************************************************************************************
void ncfiles_init(s_nc_all_files *b){
//*************************************************************************************
	//Remplit les noms des fichiers et des variables:
	char u[]="U";
	char v[]="V";
	char w[]="W";
	char axis[]="axis";
	char modulo[]="modulo";
	char origin[]="time_origin";
	char units[]="units";
	char missing[]="missing_value";
	char fill[]="_FillValue";
	char xu[]="XU_I180_540";
#ifdef YEAR_90_ON
	char yu[]="YU_J";
#else
	char yu[]="YU_J1_199";
#endif
	char zt[]="ZT_K1_30";
	char xt[]="XT_I181_540";
	char zw[]="ZW_K1_30";
	char date[]="TIME1";
#ifdef YEAR_96_OFF
	char yt[]="YT_J2_200";
	char yt_edges[]="YT_J2_200edges";
#else
	char yt[]="YT_J";
	char yt_edges[]="YT_Jedges";
#endif
	char zt_edges[]="ZT_K1_30edges";
	UNITSCPY(x)
	UNITSCPY(y)
	UNITSCPY(z)
	UNITSCPY(date)
	ORIGCPY
	AXISCPY(date)
	AXISCPY(x)
	AXISCPY(y)
	AXISCPY(z)
	MODULOCPY
	XUCPY(u)
	XUCPY(v)
	XTCPY(w)
	EDGESCPY(u)
	EDGESCPY(v)
	EDGESCPY(w)
	DATECPY
	VARCPY(u)
	VARCPY(v)
	VARCPY(w)

	//attention ceci ouvre les fichiers sans toutefois les fermer.
	nccourant_init(&(b->u));
	nccourant_init(&(b->v));
	nccourant_init(&(b->w));
	nctopo_init(&(b->topo));
	ncedges_init(b);

	return;
}

//*************************************************************************************
void nccourant_init(s_nc_input *u){
//*************************************************************************************
	int status;
	//remplit les champs de u->file
	//remplit les champs de u->var
	//remplit les champs de u->xyzdate
	H(NC_OPEN)
	H(NC_INQ)
	H(NC_INQ_VARID(var,id))
	H(NC_INQ_VARID(x,varid))
	H(NC_INQ_VARID(y,varid))
	H(NC_INQ_VARID(z,varid))
	H(NC_INQ_VARID(date,varid))
	H(NC_INQ_VAR(var,id))
	H(NC_INQ_VAR(x,varid))
	H(NC_INQ_VAR(y,varid))
	H(NC_INQ_VAR(z,varid))
	H(NC_INQ_VAR(date,varid))
	H(NC_INQ_DIMID(x))
	H(NC_INQ_DIMID(y))
	H(NC_INQ_DIMID(z))
	H(NC_INQ_DIMID(date))
	H(NC_INQ_DIM(x))
	H(NC_INQ_DIM(y))
	H(NC_INQ_DIM(z))
	H(NC_INQ_DIM(date))
	H(NC_INQ_ATTID(var,id,missing))
	H(NC_INQ_ATTID(var,id,fill))
	H(NC_INQ_ATTID(var,id,units))
	H(NC_INQ_ATTID(x,varid,axis))
	H(NC_INQ_ATTID(y,varid,axis))
	H(NC_INQ_ATTID(z,varid,axis))
	H(NC_INQ_ATTID(date,varid,axis))
	H(NC_INQ_ATTID(x,varid,units))
	H(NC_INQ_ATTID(y,varid,units))
	H(NC_INQ_ATTID(z,varid,units))
	H(NC_INQ_ATTID(date,varid,units))
	H(NC_INQ_ATTID(x,varid,modulo))
	H(NC_INQ_ATTID(date,varid,origin))
	H(NC_INQ_ATT(var,id,missing))
	H(NC_INQ_ATT(var,id,fill))
	H(NC_INQ_ATT(var,id,units))
	H(NC_INQ_ATT(x,varid,axis))
	H(NC_INQ_ATT(y,varid,axis))
	H(NC_INQ_ATT(z,varid,axis))
	H(NC_INQ_ATT(date,varid,axis))
	H(NC_INQ_ATT(x,varid,units))
	H(NC_INQ_ATT(y,varid,units))
	H(NC_INQ_ATT(z,varid,units))
	H(NC_INQ_ATT(date,varid,units))
	H(NC_INQ_ATT(x,varid,modulo))
	H(NC_INQ_ATT(date,varid,origin))
	return;
}

//*************************************************************************************
void ncedges_init(s_nc_all_files *b){
//*************************************************************************************
	int status;
	H(nc_inq_varid(b->u.file.ncid, b->u.z_edges.name_p, &(b->u.z_edges.varid)))
	H(nc_inq_varid(b->v.file.ncid, b->v.z_edges.name_p, &(b->v.z_edges.varid)))
	H(nc_inq_varid(b->w.file.ncid, b->w.y_edges.name_p, &(b->w.y_edges.varid)))
	H(nc_inq_var(b->u.file.ncid, b->u.z_edges.varid, b->u.z_edges.name_p, &(b->u.z_edges.type), &(b->u.z_edges.ndims), b->u.z_edges.dimshape_p, &(b->u.z_edges.natts)))
	H(nc_inq_var(b->v.file.ncid, b->v.z_edges.varid, b->v.z_edges.name_p, &(b->v.z_edges.type), &(b->v.z_edges.ndims), b->v.z_edges.dimshape_p, &(b->v.z_edges.natts)))
	H(nc_inq_var(b->w.file.ncid, b->w.y_edges.varid, b->w.y_edges.name_p, &(b->w.y_edges.type), &(b->w.y_edges.ndims), b->w.y_edges.dimshape_p, &(b->w.y_edges.natts)))
	H(nc_inq_dimid(b->u.file.ncid, b->u.z_edges.name_p, &(b->u.z_edges.id)))
	H(nc_inq_dimid(b->v.file.ncid, b->v.z_edges.name_p, &(b->v.z_edges.id)))
	H(nc_inq_dimid(b->w.file.ncid, b->w.y_edges.name_p, &(b->w.y_edges.id)))
	H(nc_inq_dim(b->u.file.ncid, b->u.z_edges.id, b->u.z_edges.name_p, &(b->u.z_edges.length)))
	H(nc_inq_dim(b->v.file.ncid, b->v.z_edges.id, b->v.z_edges.name_p, &(b->v.z_edges.length)))
	H(nc_inq_dim(b->w.file.ncid, b->w.y_edges.id, b->w.y_edges.name_p, &(b->w.y_edges.length)))
	return;
}

//*************************************************************************************
void ncfiles_close(s_nc_all_files *b){
//*************************************************************************************
	int status;
	H(NC_CLOSE(u))
	H(NC_CLOSE(v))
	H(NC_CLOSE(w))
	H(NC_CLOSE(topo))
	return;
}

//*************************************************************************************
void nctopo_init(s_nc_input_t *topo){
//*************************************************************************************
	int status;

	build_input_t(topo);

	//OPEN FILE
	status = nc_open( topo->file.name_p, NC_NOWRITE, &(topo->file.ncid));
	CDF_ERROR

	//INQ_FILE
	status = nc_inq(topo->file.ncid, &(topo->file.ndims), &(topo->file.nvars),&(topo->file.ngatts), &(topo->file.unlimdimip));
	CDF_ERROR

	fill_var_xyz_s(&(topo->var), "LANDMASK");
//	fill_att_s(&(topo->var.missing), "missing_value");
	fill_att_s(&(topo->var.fill), "_FillValue");

	fill_dim_s(&(topo->x), "XU_I180_540");
	fill_att_s(&(topo->x.axis), "axis");
	fill_att_s(&(topo->x.units), "units");
	
	fill_dim_s(&(topo->y), "YU_J1_199");
	fill_att_s(&(topo->y.axis), "axis");
	fill_att_s(&(topo->y.units), "units");
	
	fill_dim_s(&(topo->y_edges), "YU_J1_199edges");
	
	fill_dim_s(&(topo->z), "ZT_K1_30");
	fill_att_s(&(topo->z.axis), "axis");
	fill_att_s(&(topo->z.units), "units");
	
	fill_dim_s(&(topo->z_edges), "ZT_K1_30edges");
	

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
	status = nc_inq_attid( *(a_p->file_id_p), *(a_p->var_id_p), a_p->name_p, &(a_p->id));
	CDF_ERROR
	
	//INQ_ATT
	inq_att(a_p);

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

void build_input_t(s_nc_input_t* topo){
	build_variable_xyz( &(topo->var), &(topo->file), &(topo->x.id), &(topo->y.id), &(topo->z.id));
	build_dimension( &(topo->x), &(topo->file));
	build_dimension( &(topo->y), &(topo->file));
	build_dimension( &(topo->z), &(topo->file));
	build_dimension( &(topo->y_edges), &(topo->file));
	build_dimension( &(topo->z_edges), &(topo->file));
	return;
}

/***********************************************************************************************/
/*
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
*/
/***********************************************************************************************/
