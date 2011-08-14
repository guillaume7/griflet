#include "stdafx.h"

#define NN 5

#define CDF_DEF_DIM(s) nc_def_dim(c->out.file.ncid, c->out.s.name_p, p->s.P, &(c->out.s.id))
#define CDF_DEF_DVAR(s) nc_def_var(c->out.file.ncid,c->out.s.name_p, NC_FLOAT, NDDIM, &(c->out.s.id), &(c->out.s.varid));
#define CDF_DEF_CVAR(s) nc_def_var(c->out.file.ncid, c->out.s.name_p, NC_FLOAT, NVDIM, Cdimshape_p, &(c->out.s.id));
#define CDF_DEF_UVAR(s) nc_def_var(c->out.file.ncid, c->out.s.name_p, NC_FLOAT, NUDIM, Udimshape_p, &(c->out.s.id));
#define CDF_DEF_BVAR(s) nc_def_var(c->out.file.ncid, c->out.s.name_p, NC_SHORT, NUDIM, Udimshape_p, &(c->out.s.id));
#define CDF_COPY_DATT(s,at) nc_copy_att(c->u.file.ncid, c->u.s.varid, c->u.s.at.name_p, c->out.file.ncid, c->out.s.varid); strcpy(c->out.s.at.name_p,c->u.s.at.name_p);
#define CDF_COPY_ATT(in,ou,at) nc_copy_att(c->u.file.ncid, c->u.in.id, c->u.in.at.name_p, c->out.file.ncid, c->out.ou.id); strcpy(c->out.ou.at.name_p,c->u.in.at.name_p);
#define CDF_PUT_F_ATT(varin, varou, at, val) nc_put_att_float(c->out.file.ncid, c->out.varou.id, c->u.varin.at.name_p, NC_FLOAT, 1, val); strcpy(c->out.varou.at.name_p,c->u.varin.at.name_p);
#define CDF_PUT_S_ATT(varin, varou, at, val) nc_put_att_short(c->out.file.ncid, c->out.varou.id, c->u.varin.at.name_p, NC_SHORT, 1, val); strcpy(c->out.varou.at.name_p,c->u.varin.at.name_p);

#define CDF_INQ_VAR(s,id) nc_inq_var(c->out.file.ncid, c->out.s.id, c->out.s.name_p, &(c->out.s.type), &(c->out.s.ndims), c->out.s.dimshape_p, &(c->out.s.natts))
#define CDF_INQ_DIM(s)   nc_inq_dim(c->out.file.ncid, c->out.s.id, c->out.s.name_p, &(c->out.s.length))
#define CDF_INQ_ATTID(s,sid,n) nc_inq_attid(c->out.file.ncid, c->out.s.sid, c->out.s.n.name_p, &(c->out.s.n.id));
#define CDF_INQ_ATT(s,sid,n) nc_inq_att(c->out.file.ncid, c->out.s.sid, c->out.s.n.name_p, &(c->out.s.n.type), &(c->out.s.n.length))

#define CDF_FILL_DIM(s,q)   cdf_fill_dim( c->u.file.ncid, c->out.file.ncid, &(c->out.s), &(c->u.s), p->user.subindL.q[0]);
#define CDF_FILL_VAR(s,q) 	cdf_fill_var(c->out.file.ncid, b->s, &(c->out.q), &(c->out));
#define CDF_FILL_BVAR(s,q) 	cdf_fill_bvar(c->out.file.ncid, b->s, &(c->out.q), &(c->out));

//*****************************************************************************************
//Creer un nouveau fichier netcdf de output avec mes valeurs... Semble ok				//*
//Reproduit les dimensions et les variables des fichiers u,v et w... Semble ok			//*
//Creer les variables FR frontieres et SO de source... Semble ok						//*
//Creer la variable C de concentration... Semble ok										//*
//Copier les attributs... Semble ok														//*
//Creer les attributs pour C, FR et SO... Semble ok et a finir (plus tard)				//*
//Inserer les valeurs dans les dimensions... A tester									//*
//Inserer les valeurs dans u,v et w a partir des blocs... A tester						//*
//Inserer les valeurs dans FR et SO... A tester											//*
//Attention! La date n'a rien a voir maintenant avec le temps en output!				//*
void cdf_new(s_nc_all_files *c, s_all_parameters *p, s_memory_blocs *b){									//*
//*****************************************************************************************
	int status;
	int Cdimshape_p[NVDIM];
	int Udimshape_p[NVDIM-1];
	float val;
	float range[2];
	short int short_fill;
	c->out.file.name_p=p->filename; //Passe le nom du fichier de output.
	strcpy(c->out.x.name_p,"X");	//Passe le nom des dimensions.
	strcpy(c->out.y.name_p,"Y");
	strcpy(c->out.time.name_p,"TIME");
	strcpy(c->out.c.name_p,"C"); //Passe le nom de la variable de concentration.
	strcpy(c->out.u.name_p,"U");
	strcpy(c->out.v.name_p,"V");
#ifdef BLOC_DIM_3D
	strcpy(c->out.z.name_p,"Z");
	strcpy(c->out.w.name_p,"W");
#endif
	strcpy(c->out.fr.name_p,"FR");
	strcpy(c->out.so.name_p,"SO");
	H(nc_create(c->out.file.name_p, NC_CLOBBER, &(c->out.file.ncid)))
	//Definit les dimensions, leurs variables respectives, et leurs attributs.
	//Manque de creer les attributs pour la variable time! (optionnel)
	H(CDF_DEF_DIM(x))
	H(CDF_DEF_DIM(y))
	H(nc_def_dim(c->out.file.ncid, c->out.time.name_p, p->x.N/p->x.D+1, &(c->out.time.id)))
	H(CDF_DEF_DVAR(x))
	H(CDF_DEF_DVAR(y))
	H(CDF_DEF_DVAR(time))
	H(CDF_COPY_DATT(x,axis))
	H(CDF_COPY_DATT(y,axis))
	H(CDF_COPY_DATT(x,units))
	H(CDF_COPY_DATT(y,units))
#ifdef  BLOC_DIM_3D
	H(CDF_DEF_DIM(z))
	H(CDF_DEF_DVAR(z))
	H(CDF_COPY_DATT(z,axis))
	H(CDF_COPY_DATT(z,units))
#endif
	//Definit les variables et leurs attributs. 
    Cdimshape_p[O_TIME]=c->out.time.id;
	Cdimshape_p[O_LAT]=c->out.y.id;
	Cdimshape_p[O_LON]=c->out.x.id;
	Udimshape_p[U_LAT]=c->out.y.id;
	Udimshape_p[U_LON]=c->out.x.id;
#ifdef  BLOC_DIM_3D
	Udimshape_p[U_DEPTH]=c->out.z.id;
	Cdimshape_p[O_DEPTH]=c->out.z.id;
#endif
#ifdef CALCSWITCH_ON
	H(CDF_DEF_CVAR(c))
#endif
	H(CDF_DEF_UVAR(u))
	H(CDF_DEF_UVAR(v))
#ifdef  BLOC_DIM_3D
	H(CDF_DEF_UVAR(w))
#endif
	H(CDF_DEF_BVAR(fr))
	H(CDF_DEF_BVAR(so))
	val=MYFILL;
	short_fill=-32767;
	range[0]=0.0;
	range[1]=1.0;
#ifdef CALCSWITCH_ON
	H(CDF_PUT_F_ATT(var, c, fill, &(val)))
	H(CDF_PUT_F_ATT(var, c, missing, &(val)))
	H(CDF_COPY_ATT(var,c,units))
	H(nc_put_att_float(c->out.file.ncid, c->out.c.id, "valid_range", NC_FLOAT, 2, range))
#endif
	H(CDF_PUT_F_ATT(var, u, fill, &(val)))
	H(CDF_PUT_F_ATT(var, u, missing, &(val)))
	H(CDF_COPY_ATT(var,u,units))
	H(CDF_PUT_F_ATT(var, v, fill, &(val)))
	H(CDF_PUT_F_ATT(var, v, missing, &(val)))
	H(CDF_COPY_ATT(var,v,units))

	H(CDF_PUT_S_ATT(var, fr, fill, &(short_fill)))

#ifdef  BLOC_DIM_3D
	H(CDF_PUT_F_ATT(var, w, fill, &(val)))
	H(CDF_PUT_F_ATT(var, w, missing, &(val)))
	H(CDF_COPY_ATT(var,w,units))
#endif
	//Remplit les champs des dimensions et des variables.
#ifdef CALCSWITCH_ON
	H(CDF_INQ_VAR(c,id))
#endif
	H(CDF_INQ_VAR(so,id))
	H(CDF_INQ_VAR(fr,id))
	H(CDF_INQ_VAR(u,id))
	H(CDF_INQ_VAR(v,id))
	H(CDF_INQ_VAR(x,varid))
	H(CDF_INQ_VAR(y,varid))
	H(CDF_INQ_VAR(time,varid))
	H(CDF_INQ_DIM(x))
	H(CDF_INQ_DIM(y))
#ifdef  BLOC_DIM_3D
	H(CDF_INQ_VAR(w,id))
	H(CDF_INQ_VAR(z,varid))
	H(CDF_INQ_DIM(z))
#endif
	H(CDF_INQ_DIM(time))
#ifdef CALCSWITCH_ON
	H(CDF_INQ_ATTID(c,id,missing))
	H(CDF_INQ_ATTID(c,id,fill))
	H(CDF_INQ_ATTID(c,id,units))
#endif
	H(CDF_INQ_ATTID(u,id,missing))
	H(CDF_INQ_ATTID(u,id,fill))
	H(CDF_INQ_ATTID(u,id,units))
	H(CDF_INQ_ATTID(v,id,missing))
	H(CDF_INQ_ATTID(v,id,fill))
	H(CDF_INQ_ATTID(v,id,units))
	H(CDF_INQ_ATTID(x,varid,axis))
	H(CDF_INQ_ATTID(y,varid,axis))
	H(CDF_INQ_ATTID(x,varid,units))
	H(CDF_INQ_ATTID(y,varid,units))
#ifdef CALCSWITCH_ON
	H(CDF_INQ_ATT(c,id,missing))
	H(CDF_INQ_ATT(c,id,fill))
	H(CDF_INQ_ATT(c,id,units))
#endif
	H(CDF_INQ_ATT(u,id,missing))
	H(CDF_INQ_ATT(u,id,fill))
	H(CDF_INQ_ATT(u,id,units))
	H(CDF_INQ_ATT(v,id,missing))
	H(CDF_INQ_ATT(v,id,fill))
	H(CDF_INQ_ATT(v,id,units))
	H(CDF_INQ_ATT(x,varid,axis))
	H(CDF_INQ_ATT(y,varid,axis))
	H(CDF_INQ_ATT(x,varid,units))
	H(CDF_INQ_ATT(y,varid,units))
#ifdef BLOC_DIM_3D
	H(CDF_INQ_ATTID(w,id,missing))
	H(CDF_INQ_ATTID(w,id,fill))
	H(CDF_INQ_ATTID(w,id,units))
	H(CDF_INQ_ATTID(z,varid,axis))
	H(CDF_INQ_ATTID(z,varid,units))
	H(CDF_INQ_ATT(w,id,missing))
	H(CDF_INQ_ATT(w,id,fill))
	H(CDF_INQ_ATT(w,id,units))
	H(CDF_INQ_ATT(z,varid,axis))
	H(CDF_INQ_ATT(z,varid,units))
#endif
	H(nc_enddef(c->out.file.ncid))
	//Insere les valeurs dans les dimensions (excepte le temps).
	CDF_FILL_DIM(x,lon_p)
	CDF_FILL_DIM(y,lat_p)
#ifdef BLOC_DIM_3D
	CDF_FILL_DIM(z,depth_p)
#endif
	cdf_fill_time(&(c->out), p);
	//Insere les valeurs dans les variables u,v,w,so et fr.
	CDF_FILL_VAR(V_u,u)
	CDF_FILL_VAR(V_v,v)
#ifdef BLOC_DIM_3D
	CDF_FILL_VAR(V_w,w)
#endif
	CDF_FILL_BVAR(C_so,so)
	CDF_FILL_BVAR(C_fr,fr)
	return;
}

//*****************************************************************************************
//Remplit les valeurs de la variable a partir du bloc_t.
//Attention, ca n'a pas besoin du temps pour rien!
void cdf_fill_var(int ncid, bloc_t v, s_nc_variable_xyz *ncv, s_nc_result* c){
//*****************************************************************************************
	int status;
	float value;
	size_t ind_p[NUDIM];
	size_t *i,*j;
#ifdef BLOC_DIM_3D
	size_t *k;
	k=&(ind_p[U_DEPTH]);
#endif
	i=&(ind_p[U_LON]);
	j=&(ind_p[U_LAT]);
#ifdef BLOC_DIM_3D
	for(*k=0;*k<c->z.length;(*k)++){
#endif
		for(*i=0;*i<c->x.length;(*i)++){
			for(*j=0;*j<c->y.length;(*j)++){
				value=CDF_BLC;
				H(nc_put_var1_float(ncid, ncv->id, ind_p, &(value)));
			}
		}
#ifdef BLOC_DIM_3D
	}
#endif
	return;
}

//*****************************************************************************************
//Remplit les valeurs de la variable a partir du b_bloc_t.
void cdf_fill_bvar(int ncid, b_bloc_t v, s_nc_variable_xyz *ncv, s_nc_result* c){
//*****************************************************************************************
	int status;
	short value;
	size_t ind_p[NUDIM];
	size_t *i,*j;
#ifdef BLOC_DIM_3D
	size_t *k;
	k=&(ind_p[U_DEPTH]);
#endif
	i=&(ind_p[U_LON]);
	j=&(ind_p[U_LAT]);
#ifdef BLOC_DIM_3D
	for(*k=0;*k<c->z.length;(*k)++){
#endif
		for(*i=0;*i<c->x.length;(*i)++){
			for(*j=0;*j<c->y.length;(*j)++){
				value=(short) CDF_BLC;
				H(nc_put_var1_short(ncid, ncv->id, ind_p, &(value)))
			}
		}
#ifdef BLOC_DIM_3D
	}
#endif
	return;
}

//*****************************************************************************************
//Remplit les valeurs de la variable dimension.
void cdf_fill_dim( int ncfrid, int nctoid, s_nc_dimension* to, s_nc_dimension* from, size_t start){
//*****************************************************************************************
	int status;
	float value1, value2;
	size_t i,q;
	q=start;
	value2=-100.0;
	for(i=0;i<to->length;i++){
		H(nc_get_var1_float(ncfrid, from->varid, &q, &value1))
		if(value1<value2) value2=value1+MODULO_DEG;
		else value2=value1;
		H(nc_put_var1_float(nctoid, to->varid, &i, &value2))
		q=(q+1)%(from->length);
	}
	return;
}

//*****************************************************************************************
//Ferme le fichier netcdf de output.
void cdf_close(s_nc_file* out){
//*****************************************************************************************
	nc_close(out->ncid);
	return;
}

//*****************************************************************************************
//Remplit les valeurs de la variable time.
void cdf_fill_time(s_nc_result* c, s_all_parameters* p){
//*****************************************************************************************
	int status;
	index_t i,n;
	float* val_p;
	n=p->x.N/p->x.D+1; //Ceci est le nombre total d'iterations.
	val_p = (float*) malloc(n*sizeof(float));
	for(i=0;i<n;i++) val_p[i]=i*1.0;
	H(nc_put_var_float(c->file.ncid, c->time.varid, val_p))
	return;
}

//*****************************************************************************************
//Writes the data of the traceur.
int cdf_write( bloc_t data, s_all_parameters *t, s_nc_result *c, index_t time){
//*****************************************************************************************
	int status;
	float value;
	size_t ip[NVDIM];
	index_t *i, *j;
#ifdef BLOC_DIM_3D
	index_t *k;
	k=&(ip[O_DEPTH]);
#endif
	i=&(ip[O_LON]);
	j=&(ip[O_LAT]);
	ip[O_TIME]=time;
#ifdef BLOC_DIM_2D
	for(*i=0;*i<t->x.P;(*i)++){
		for(*j=0;*j<t->y.P;(*j)++){
			value=data[*i][*j];
			if(value<EPS) value=MYFILL;
			H(nc_put_var1_float(c->file.ncid, c->c.id, ip, &(value)))
		}
	}
#endif
#ifdef BLOC_DIM_3D
	for(*k=0;*k<t->z.P;(*k)++){
		for(*i=0;*i<t->x.P;(*i)++){
			for(*j=0;*j<t->y.P;(*j)++){
				value=data[*k][*i][*j];
				if(value<EPS) value=MYFILL;
				H(nc_put_var1_float(c->file.ncid, c->c.id, ip, &(value)))
			}
		}
	}
#endif
	return 0;
}
