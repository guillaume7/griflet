/*****************routines sur les s_memory_blocs*****************/
#include "stdafx.h"

#ifdef BLOC_DIM_2D //////////////////////////////////////////////
//---------------------------------------------------------------
#define ALL_FILL t->x.P,t->y.P,ALL_INC
#define FREE_FILL t->x.P,ALL_INC
#define BLC_ALLOC table_alloc(ALL_FILL)
#define B_BLC_ALLOC b_table_alloc(ALL_FILL)
#define BLC_FREE(s) table_free(s,FREE_FILL)
#define B_BLC_FREE(s) b_table_free(s,FREE_FILL)
#define BLC_OLD b->C_old[i][j]
#define BLC_SO b->C_so[i][j]
#define BLC_FR b->C_fr[i][j]
#define BLC_U(s) b->V_u[i][s]
#define BLC_V(s) b->V_v[s][j]
#define DEC_BLC(s) dec_table(t->x.P,&(s))
#define DEC_B_BLC(s) b_dec_table(t->x.P,&(s))
#define INC_BLC(s) inc_table(t->x.P,&(s))
#define INC_B_BLC(s) b_inc_table(t->x.P,&(s))
#define IJ [g->i][g->j]
#define IPJ [g->ip][g->j]
#define INJ [g->in][g->j]
#define IJP [g->i][g->jp]
#define IJN [g->i][g->jn]
//---------------------------------------------------------------
#endif ////////////////////////////////////////////////////////////

#ifdef BLOC_DIM_3D /////////////////////////////////////////////////
//---------------------------------------------------------------
#define ALL_FILL t->z.P,t->x.P,t->y.P,ALL_INC
#define FREE_FILL t->z.P,t->x.P,ALL_INC
#define BLC_ALLOC cube_alloc(ALL_FILL)
#define B_BLC_ALLOC b_cube_alloc(ALL_FILL)
#define BLC_FREE(s) cube_free(s,FREE_FILL)
#define B_BLC_FREE(s) b_cube_free(s,FREE_FILL)
#define BLC_OLD b->C_old[k][i][j]
#define BLC_SO b->C_so[k][i][j]
#define BLC_FR b->C_fr[k][i][j]
#define BLC_U(s) b->V_u[k][i][s]
#define BLC_V(s) b->V_v[k][s][j]
#define BLC_W b->V_w[k][i][j]
#define DEC_BLC(s) dec_cube(t->z.P,t->x.P,&(s))
#define DEC_B_BLC(s) b_dec_cube(t->z.P,t->x.P,&(s))
#define INC_BLC(s) inc_cube(t->z.P,t->x.P,&(s))
#define INC_B_BLC(s) b_inc_cube(t->z.P,t->x.P,&(s))
#define IJ [g->k][g->i][g->j]
#define IPJ [g->k][g->ip][g->j]
#define INJ [g->k][g->in][g->j]
#define IJP [g->k][g->i][g->jp]
#define IJN [g->k][g->i][g->jn]
#define KP [g->kp][g->i][g->j]
#define KN [g->kn][g->i][g->j]
//---------------------------------------------------------------
#endif////////////////////////////////////////////////////////////

#define P_I_UP	t->x.a*b->u_p[g->j]
#define C_I_UP	t->x.a*b->u_p[g->j]
#define C_I_U	t->x.a*u
#define N_I_U	t->x.a*u	

#define P_I_DIFF	t->x.b
#define C_I_DIFF	t->x.b
#define N_I_DIFF	t->x.b

#define P_J_VP	b->j.a[g->jp]*v_p
#define C_J_VP	b->j.a[g->j]*v_p
#define C_J_V	b->j.a[g->j]*v
#define N_J_V	b->j.a[g->jn]*v	

#define P_J_DIFF	b->j.b[g->jp]
#define C_J_DIFF	b->j.b[g->j]
#define N_J_DIFF	b->j.b[g->jn]

#define P_K_WP	b->k.a[g->kp]*b->w_p[g->j]
#define C_K_WP	b->k.a[g->k]*b->w_p[g->j]
#define C_K_W	b->k.a[g->k]*w
#define N_K_W	b->k.a[g->kn]*w	

#define P_K_DIFF	b->k.b[g->kp]
#define C_K_DIFF	b->k.b[g->k]
#define N_K_DIFF	b->k.b[g->kn]

#define INDEXSET(index,i,x) if(((int)index[0]=((int)t->so.i)-STAINSIZE)<0) index[0]=0;if((index[1]=t->so.i+STAINSIZE)>=t->x.P) index[1]=t->x.P-1;
#define CDF_GET_VAR1_DOUBLE(p,s) nc_get_var1_double(c->file.ncid, c->var.id, p, &(s))
#define CDF_GET_VAR1_FLOAT(p,s) nc_get_var1_float(c->file.ncid, c->var.id, p, &(s))
#define CDF_GET_DIM1_FLOAT(p,q,s) nc_get_var1_float(c->p.file.ncid, c->p.q.varid, ip, &(s))

//**********************Cree des blocs de memoire pour contenir l'information.*************
void create_blocs( s_all_parameters *t, s_memory_blocs *b){										//*
//*****************************************************************************************
	b->C_old = BLC_ALLOC;
	b->C_new = BLC_ALLOC;
	b->C_so = B_BLC_ALLOC;	//Ce n'est pas si important s'il s'agit d'une source ponctuelle.
	b->C_fr = B_BLC_ALLOC;
	b->V_u 	= BLC_ALLOC;	//Je vais reemployer les blocs de vitesses pour les coeffs p,c,n.
	b->V_v 	= BLC_ALLOC;	//idem

#ifdef BLOC_DIM_3D//////////////////////////////////////////////
//---------------------------------------------------------------
	b->V_w 	= BLC_ALLOC;	//idem ibidem
	b->k.a	= array_alloc(t->z.P,ALL_INC);
	b->k.b	= array_alloc(t->z.P,ALL_INC);
	b->k.g	= array_alloc(t->z.P,ALL_INC);
	b->w_p	= array_alloc(t->y.P,ALL_INC);
	b->u_p	= array_alloc(t->y.P,ALL_INC);
	b->j.a	= array_alloc(t->y.P,ALL_INC);
	b->j.b	= array_alloc(t->y.P,ALL_INC);
	b->i.p  = b->V_u;
	b->i.c  = b->V_v;
	b->i.n  = b->V_w;
	b->j.p  = BLC_ALLOC;
	b->j.c  = b->i.c;		//Pour i, il suffit de copier l'addresse de i.
	b->j.n  = BLC_ALLOC;
	b->k.p  = BLC_ALLOC;
	b->k.c  = BLC_ALLOC;
	b->k.n  = BLC_ALLOC;
//---------------------------------------------------------------
#else///////////////////////////////////////////////////////////
//---------------------------------------------------------------
	b->u_p	= array_alloc(t->y.P,ALL_INC);
	b->j.a	= array_alloc(t->y.P,ALL_INC);
	b->j.b	= array_alloc(t->y.P,ALL_INC);
	b->i.p  = BLC_ALLOC;
	b->i.c  = BLC_ALLOC;
	b->i.n  = BLC_ALLOC;
	b->j.p  = BLC_ALLOC;
	b->j.c  = b->i.c;		//Pour i, il suffit de copier l'addresse de i.
	b->j.n  = BLC_ALLOC;
//---------------------------------------------------------------
#endif///////////////////////////////////////////////////////////

	return;
}

//***************Remplit la matrice masque de la source de traceur dans l'ocean.*********
void fill_stain(s_all_parameters *t, s_memory_blocs *b){										//	*
//***************************************************************************************

#ifdef POINTSOURCE_OFF //////////////////////////////////////////////////////////////////
//-----------------Si la source est une tache qui occupe plusieurs cases-----------------
	int inde_x[2], inde_y[2]; //Les indices delimitant la gauche et la droite.
	index_t i, j;
#ifdef BLOC_DIM_3D
	int inde_z[2];
	index_t k;
#endif
#ifdef BLOC_DIM_3D
	INDEXSET(inde_z,k,z)
	for(k=inde_z[0];k<=inde_z[1];k++){
#endif
		INDEXSET(inde_x, i,x)
		for(i=inde_x[0];i<=inde_x[1];i++){
			INDEXSET(inde_y, j,y)
			for(j=inde_y[0];j<=inde_y[1];j++) BLC_SO = TRUE;
		}
#ifdef BLOC_DIM_3D
	}
#endif
//--------------------------------------------------------------------------------------
#endif//////////////////////////////////////////////////////////////////////////////////

#ifdef POINTSOURCE_ON //////////////////////////////////////////////////////////////////
//-------------------Si la source n'occupe qu'une case de la grille---------------------
	index_t i,j;
#ifdef BLOC_DIM_3D
	index_t k;
	k=t->so.k;
#endif
	i=t->so.i;
	j=t->so.j;
	BLC_SO=TRUE;
//--------------------------------------------------------------------------------------
#endif//////////////////////////////////////////////////////////////////////////////////

//----------------------On remplit la condition initiale du traceur (à t=0)-------------
#ifdef BLOC_DIM_3D
	for(k=0;k<t->z.P;k++){
#endif
		for(i=0;i<t->x.P;i++){
			for(j=0;j<t->y.P;j++){
				BLC_OLD = (double) BLC_SO*t->so.coninit;
			}
		}
#ifdef BLOC_DIM_3D
	}
#endif
//----------------------------------------------------------------------------------------

	return;
}

//*************Remplit les matrices d'advection et le masque des frontieres.****************
void fill_adv(s_nc_all_files *n, s_all_parameters *t, s_memory_blocs *b){							//	*
//******************************************************************************************
	index_t i, j;
#ifdef BLOC_DIM_3D
	index_t k;
#endif
	double aux1, aux2;

//-----------Decremente le pointeur des blocs frontieres et vitesses------------------------
	DEC_B_BLC(b->C_fr);
	DEC_BLC(b->V_u);
	DEC_BLC(b->V_v);
#ifdef BLOC_DIM_3D
	DEC_BLC(b->V_w);
#endif
//------------------------------------------------------------------------------------------

//--------Remplit les blocs des vitesses et des frontieres----------------------------------
	cdf_dataread(&(n->u), b->V_u, b->C_fr, t); //Remplit u et les frontieres.
	cdf_dataread(&(n->v), b->V_v, NULL, t); //Remplit v seulement.
#ifdef BLOC_DIM_3D
	cdf_dataread(&(n->w), b->V_w, NULL, t); //Remplit w seulement.
#endif
//------------------------------------------------------------------------------------------

//---------Transforme les vitesses des cellules U en vitesses traitables par notre modele----
#ifdef BLOC_DIM_3D
	for(k=1;k<t->z.P+B_K_INC;k++){	//Atention: ceci n'est valable qu'en dessous de la surface.
#endif
		//ReRemplissage du bloc u.
		for(i=0;i<t->x.P+B_INC;i++){
			aux2=0.5*(BLC_U(1)+BLC_U(0));
			for(j=1;j<t->y.P+B_INC;j++){
				aux1=aux2;
				aux2=0.5*(BLC_U(j+1)+BLC_U(j));
				BLC_U(j)=aux1;
			}
		}
		//ReRemplissage du bloc v.
		for(j=0;j<t->y.P+B_INC;j++){
			aux2=0.5*(BLC_V(1)+BLC_V(0));
			for(i=1;i<t->x.P+B_INC;i++){
				aux1=aux2;
				aux2=0.5*(BLC_V(i+1)+BLC_V(i));
				BLC_V(i)=aux1;
			}
		}
#ifdef BLOC_DIM_3D
	}
#endif
//------------------------------------------------------------------------------------------

//------Incremente les pointeurs des blocs frontieres et vitesses---------------------------
#ifdef BLOC_DIM_3D
	INC_BLC(b->V_w);
#endif
	INC_BLC(b->V_v);
	INC_BLC(b->V_u);
	INC_B_BLC(b->C_fr);
//------------------------------------------------------------------------------------------

	return;
}

//*****************************************************************************************
//Doit lire les champs de vitesses et remplir les blocs de memoire 
//des vitesses et des frontieres.
//U(TIME,DEPTH,LATITUDE,LONGITUDE), NVDIM=nbre de dims.
void cdf_dataread(s_nc_input* c, bloc_t v, b_bloc_t fr, s_all_parameters* p){		
//*****************************************************************************************
	double value;
	double aux;
	size_t i,j;
#ifdef BLOC_DIM_3D
	size_t k;
#endif

//-------Ici on fait l'integration et la moyenne des vitesses-----------------------------
	cdf_adv_integration(c, v, p);
//-----------------------------------------------------------------------------------------

//-------Ici on applique les frontieres aux blocs des vitesses et des frontieres------
#ifdef BLOC_DIM_3D
	for(k=1;k<p->z.P+B_K_INC;k++){
#endif
	for(i=0;i<p->x.P+B_INC;i++){
	for(j=0;j<p->y.P+B_INC;j++){
			value=V_BLC;
			aux=FILLVALUE+value;
			if(aux<COMP_FILL){
				if(fr!=NULL)FR_BLC = FALSE;
				V_BLC = MYFILL;   //Ici on doit avoir zero.
			}
			else{
				if(fr!=NULL) FR_BLC = TRUE;
				V_BLC = value; //Garde la valeur dans le bloc.
			}
	}
	}
#ifdef BLOC_DIM_3D
	}
#endif
//-----------------------------------------------------------------------------------------

	return;
}

//*****************************************************************************************
//Doit lire les champs de vitesses et faire l'integration puis la moyenne
//U(TIME,DEPTH,LATITUDE,LONGITUDE), NVDIM=nbre de dims.
void cdf_adv_integration(s_nc_input* c, bloc_t v, s_all_parameters* p){			
//*****************************************************************************************
	int status;
	float value; //Attention tu vas lire un float que tu vas mettre dans un double!
	size_t ip[NVIDIM]; //Index pointer pour le netcdf.
#ifdef ANNUAL_MEAN_ON
	size_t count;	//compteur des integrations.
#endif
	size_t i,j;
#ifdef BLOC_DIM_3D
	size_t k;
#endif

//-------Ici on remplit le bloc avec les vitesses integrees------
	ip[I_TIME]=p->user.subindL.date_p[0]-1;
#ifdef ANNUAL_MEAN_ON
	for(count=0;count<MEAN;count++){
#endif

	ip[I_DEPTH]=p->user.subindL.depth_p[0];
#ifdef BLOC_DIM_3D
	for(k=1;k<p->z.P+B_K_INC;k++){
#endif
	
	ip[I_LON]=(p->user.subindL.lon_p[0]-1)%c->x.length;
	for(i=0;i<p->x.P+B_INC;i++){
	
	ip[I_LAT]=p->user.subindL.lat_p[0]-1;
	for(j=0;j<p->y.P+B_INC;j++){
	
			H(CDF_GET_VAR1_FLOAT(ip,value))
#ifdef ANNUAL_MEAN_ON/////////////////////////////////////////////////
			if(c==0)	V_BLC  = value; //somme la valeur dans le bloc.
			else		V_BLC += value; //somme la valeur dans le bloc.
#else/////////////////////////////////////////////////////////////////
			V_BLC = value;
#endif////////////////////////////////////////////////////////////////

	ip[I_LAT]++;
	}

	ip[I_LON]=(ip[I_LON]+1)%c->x.length;
	}

#ifdef BLOC_DIM_3D
	ip[I_DEPTH]++;
	}
#endif

#ifdef ANNUAL_MEAN_ON
	ip[I_TIME]++;
	}
#endif
//-----------------------------------------------------------------------------------------

#ifdef ANNUAL_MEAN_ON /////////////////////////////////////////////////////////////////////
//---------------Ici on prend la moyenne des vitesses integrees----------------------------
#ifdef BLOC_DIM_3D
	for(k=1;k<p->z.P+B_K_INC;k++){
#endif
	for(i=0;i<p->x.P+B_INC;i++){
	for(j=0;j<p->y.P+B_INC;j++){
			V_BLC /= MEAN; //Divise pour avoir une moyenne.
	}
	}
#ifdef BLOC_DIM_3D
	}
#endif	
//-----------------------------------------------------------------------------------------
#endif ////////////////////////////////////////////////////////////////////////////////////

	return;
}

//*******Remplit les coefficients a et b pour les lats et la profondeur; puis n,c et p******
void fill_coefs(s_nc_all_files *c, s_all_parameters *t, s_memory_blocs *b){
//*****************************************************************************************
	int status;
	float value1, value2;
	float u;
	float v_p, v;
#ifdef BLOC_DIM_3D
	float w;
#endif
	size_t ip[NDDIM];
	s_indexes ind;
	s_indexes *g;
	g=&ind;
//----------------Remplit les coefs a et b des lats-----------------------------------------------
	ip[0]=t->user.subindL.lat_p[0]+1;
	for(g->i=0;g->i<t->y.P;g->i++){
			H(CDF_GET_DIM1_FLOAT(w,y_edges,value1));
			ip[0]++;
			H(CDF_GET_DIM1_FLOAT(w,y_edges,value2));
#ifdef VOLUME_FIXE_OFF
			value2=fabs(value2-value1)*LONGUEUR;
#else
			value2=LONGUEUR*1.; //Un degre de resolution horizontale.
#endif
			b->j.a[g->i]=TEMPS/t->x.N/((double)value2)*VITESSE;  //res_t/res_j*vitesse
			b->j.b[g->i]=COEFDIFF_H*TEMPS/t->x.N/((double)value2)/((double)value2); //K_h*res_t/res_j/res_j
	}
//-----------------------------------------------------------------------------------------

#ifdef BLOC_DIM_3D ///////////////////////////////////////////////////////////////////////
//----------------Remplit les coefs a et b de la profondeur---------------------------------------
	ip[0]=t->user.subindL.depth_p[0];
	for(g->i=0;g->i<t->z.P;g->i++){
			H(CDF_GET_DIM1_FLOAT(u,z_edges,value1));
			ip[0]++;
			H(CDF_GET_DIM1_FLOAT(u,z_edges,value2));
#ifdef VOLUME_FIXE_OFF
			value2-=value1;
#else
			value2=10.; //Dix metres de resolution verticale.
#endif
			b->k.a[g->i]=TEMPS/t->x.N/((double)value2)*VITESSE; //res_t/res_k*vitesse
			b->k.b[g->i]=COEFDIFF_V*TEMPS/t->x.N/((double)value2)/((double)value2); //K_v*res_t/res_k/res_k
	}
//-----------------------------------------------------------------------------------------
#endif ///////////////////////////////////////////////////////////////////////////////////

//--------------Remplit les coefs p,c et n de la matrice tridiagonale----------------------
//				!!!! VOIR FICHIER EXCEL parametrisations pour les coefs!!!!
//-----Ceci est TRES DELICAT. Si le schema ne fonctionne pas alors l'erreur est ici!!!-----
#ifdef BLOC_DIM_3D
	for(g->k=0; g->k<t->z.P; g->k++){
		g->kp=g->k-1;
		g->kn=g->k+1;
#endif
	for(g->i=0; g->i<t->x.P; g->i++){
		g->ip=g->i-1;
		g->in=g->i+1;
	for(g->j=0; g->j<t->y.P; g->j++){
		g->jp=g->j-1;
		g->jn=g->j+1;

//-----------------Gardons les vitesses------------------------------------------------------
		if(g->i==0) b->u_p[g->j]=U(ip);
		u=U(i);
		if(g->j==0) v_p=V(jp);
		else v_p=v;
		v=V(j);
#ifdef BLOC_DIM_3D
		if(g->k==0) b->w_p[g->j]=W(kp);
		w=W(k);
#endif
//-------------------------------------------------------------------------------------------

//-----------------IF SCH_UP OU HY-----------------------------------------------------------
		if((t->schema==SCH_UP) || (t->schema==SCH_HY) ){
	//----------Concernant la coordonnee i---------------------------
		//advection i 
		if(b->u_p[g->j]<0.0){
			if(u<0.0){
				P(i)=P_I_UP*0;
				C(i)=C_I_UP*1;
				C(i)+=C_I_U*0;
				N(i)=N_I_U*(-1);
			}
			else{
				P(i)=P_I_UP*0;
				C(i)=C_I_UP*1;
				C(i)+=C_I_U*(-1);
				N(i)=N_I_U*0;
			}
		}
		else{
			if(u<0.0){
				P(i)=P_I_UP*1;
				C(i)=C_I_UP*0;
				C(i)+=C_I_U*0;
				N(i)=N_I_U*(-1);
			}
			else{
				P(i)=P_I_UP*1;
				C(i)=C_I_UP*0;
				C(i)+=C_I_U*(-1);
				N(i)=N_I_U*0;
			}
		}
	//---------------------------------------------------------------
	//----------Concernant la coordonnee j---------------------------
		//advection j 
		if(v_p<0.0){
			if(v<0.0){
				P(j)=P_J_VP*0;
				C(j)+=C_J_VP*1;
				C(j)+=C_J_V*0;
				N(j)=N_J_V*(-1);
			}
			else{
				P(j)=P_J_VP*0;
				C(j)+=C_J_VP*1;
				C(j)+=C_J_V*(-1);
				N(j)=N_J_V*0;
			}
		}
		else{
			if(v<0.0){
				P(j)=P_J_VP*1;
				C(j)+=C_J_VP*0;
				C(j)+=C_J_V*0;
				N(j)=N_J_V*(-1);
			}
			else{
				P(j)=P_J_VP*1;
				C(j)+=C_J_VP*0;
				C(j)+=C_J_V*(-1);
				N(j)=N_J_V*0;
			}
		}
	//---------------------------------------------------------------

#ifdef BLOC_DIM_3D///////////////////////////////////////////////////
	//----------Concernant la coordonnee k---------------------------
		//advection k 
		if(b->w_p[g->j]<0.0){
			if(w<0.0){
				P(k)=P_K_WP*0;
				C(k)=C_K_WP*1;
				C(k)+=C_K_W*0;
				N(k)=N_K_W*(-1);
			}
			else{
				P(k)=P_K_WP*0;
				C(k)=C_K_WP*1;
				C(k)+=C_K_W*(-1);
				N(k)=N_K_W*0;
			}
		}
		else{
			if(w<0.0){
				P(k)=P_K_WP*1;
				C(k)=C_K_WP*0;
				C(k)+=C_K_W*0;
				N(k)=N_K_W*(-1);
			}
			else{
				P(k)=P_K_WP*1;
				C(k)=C_K_WP*0;
				C(k)+=C_K_W*(-1);
				N(k)=N_K_W*0;
			}
		}
	//---------------------------------------------------------------
#endif///////////////////////////////////////////////////////////////

		}
//-------------------------------------------------------------------------------------------

//----------------------IF SCH_DI------------------------------------------------------------
		if(t->schema==SCH_DI){
	//----------Concernant la coordonnee i---------------------------
		//diffusion i
		if(C_FR_i(ip)==0){
			if(C_FR_i(in)==0){
				P(i)=P_I_DIFF*0;
				C(i)=C_I_DIFF*0;
				N(i)=N_I_DIFF*0;
			}
			else{
				P(i)=P_I_DIFF*0;
				C(i)=C_I_DIFF*(-1);
				N(i)=N_I_DIFF*1;
			}
		}
		else{
			if(C_FR_i(in)==0){
				P(i)=P_I_DIFF*1;
				C(i)=C_I_DIFF*(-1);
				N(i)=N_I_DIFF*0;
			}
			else{
				P(i)=P_I_DIFF*1;
				C(i)=C_I_DIFF*(-2);
				N(i)=N_I_DIFF*1;
			}
		}
	//---------------------------------------------------------------
	//----------Concernant la coordonnee j---------------------------
		//diffusion j
		if(C_FR_j(jp)==0){
			if(C_FR_j(jn)==0){
				P(j)=P_J_DIFF*0;
				C(j)+=C_J_DIFF*0;
				N(j)=N_J_DIFF*0;
			}
			else{
				P(j)=P_J_DIFF*0;
				C(j)+=C_J_DIFF*(-1);
				N(j)=N_J_DIFF*1;
			}
		}
		else{
			if(C_FR_j(jn)==0){
				P(j)=P_J_DIFF*1;
				C(j)+=C_J_DIFF*(-1);
				N(j)=N_J_DIFF*0;
			}
			else{
				P(j)=P_J_DIFF*1;
				C(j)+=C_J_DIFF*(-2);
				N(j)=N_J_DIFF*1;
			}
		}
	//---------------------------------------------------------------
#ifdef BLOC_DIM_3D///////////////////////////////////////////////////
	//----------Concernant la coordonnee k---------------------------
		//diffusion k
		if(C_FR_k(kp)==0){
			if(C_FR_k(kn)==0){
				P(k)=P_K_DIFF*0;
				C(k)=C_K_DIFF*0;
				N(k)=N_K_DIFF*0;
			}
			else{
				P(k)=P_K_DIFF*0;
				C(k)=C_K_DIFF*(-1);
				N(k)=N_K_DIFF*1;
			}
		}
		else{
			if(C_FR_k(kn)==0){
				P(k)=P_K_DIFF*1;
				C(k)=C_K_DIFF*(-1);
				N(k)=N_K_DIFF*0;
			}
			else{
				P(k)=P_K_DIFF*1;
				C(k)=C_K_DIFF*(-2);
				N(k)=N_K_DIFF*1;
			}
		}
	//---------------------------------------------------------------
#endif///////////////////////////////////////////////////////////////
		}
//-------------------------------------------------------------------------------------------

//-----------------IF SCH_UP|SCH_DI OU SCH_HY|SCH_DI-----------------------------------------
		if( (t->schema==(SCH_UP|SCH_DI)) || (t->schema==(SCH_HY|SCH_DI)) ){
	//----------Concernant la coordonnee i---------------------------
		//advection i 
		if(b->u_p[g->j]<0.0){
			if(u<0.0){
				P(i)=P_I_UP*0;
				C(i)=C_I_UP*1;
				C(i)+=C_I_U*0;
				N(i)=N_I_U*(-1);
			}
			else{
				P(i)=P_I_UP*0;
				C(i)=C_I_UP*1;
				C(i)+=C_I_U*(-1);
				N(i)=N_I_U*0;
			}
		}
		else{
			if(u<0.0){
				P(i)=P_I_UP*1;
				C(i)=C_I_UP*0;
				C(i)+=C_I_U*0;
				N(i)=N_I_U*(-1);
			}
			else{
				P(i)=P_I_UP*1;
				C(i)=C_I_UP*0;
				C(i)+=C_I_U*(-1);
				N(i)=N_I_U*0;
			}
		}
		//diffusion i
		if(C_FR_i(ip)==0){
			if(C_FR_i(in)==0){
				P(i)+=P_I_DIFF*0;
				C(i)+=C_I_DIFF*0;
				N(i)+=N_I_DIFF*0;
			}
			else{
				P(i)+=P_I_DIFF*0;
				C(i)+=C_I_DIFF*(-1);
				N(i)+=N_I_DIFF*1;
			}
		}
		else{
			if(C_FR_i(in)==0){
				P(i)+=P_I_DIFF*1;
				C(i)+=C_I_DIFF*(-1);
				N(i)+=N_I_DIFF*0;
			}
			else{
				P(i)+=P_I_DIFF*1;
				C(i)+=C_I_DIFF*(-2);
				N(i)+=N_I_DIFF*1;
			}
		}
	//---------------------------------------------------------------
	//----------Concernant la coordonnee j---------------------------
		//advection j 
		if(v_p<0.0){
			if(v<0.0){
				P(j)=P_J_VP*0;
				C(j)+=C_J_VP*1;
				C(j)+=C_J_V*0;
				N(j)=N_J_V*(-1);
			}
			else{
				P(j)=P_J_VP*0;
				C(j)+=C_J_VP*1;
				C(j)+=C_J_V*(-1);
				N(j)=N_J_V*0;
			}
		}
		else{
			if(v<0.0){
				P(j)=P_J_VP*1;
				C(j)+=C_J_VP*0;
				C(j)+=C_J_V*0;
				N(j)=N_J_V*(-1);
			}
			else{
				P(j)=P_J_VP*1;
				C(j)+=C_J_VP*0;
				C(j)+=C_J_V*(-1);
				N(j)=N_J_V*0;
			}
		}
		//diffusion j
		if(C_FR_j(jp)==0){
			if(C_FR_j(jn)==0){
				P(j)+=P_J_DIFF*0;
				C(j)+=C_J_DIFF*0;
				N(j)+=N_J_DIFF*0;
			}
			else{
				P(j)+=P_J_DIFF*0;
				C(j)+=C_J_DIFF*(-1);
				N(j)+=N_J_DIFF*1;
			}
		}
		else{
			if(C_FR_j(jn)==0){
				P(j)+=P_J_DIFF*1;
				C(j)+=C_J_DIFF*(-1);
				N(j)+=N_J_DIFF*0;
			}
			else{
				P(j)+=P_J_DIFF*1;
				C(j)+=C_J_DIFF*(-2);
				N(j)+=N_J_DIFF*1;
			}
		}
	//---------------------------------------------------------------

#ifdef BLOC_DIM_3D///////////////////////////////////////////////////
	//----------Concernant la coordonnee k---------------------------
		//advection k 
		if(b->w_p[g->j]<0.0){
			if(w<0.0){
				P(k)=P_K_WP*0;
				C(k)=C_K_WP*1;
				C(k)+=C_K_W*0;
				N(k)=N_K_W*(-1);
			}
			else{
				P(k)=P_K_WP*0;
				C(k)=C_K_WP*1;
				C(k)+=C_K_W*(-1);
				N(k)=N_K_W*0;
			}
		}
		else{
			if(w<0.0){
				P(k)=P_K_WP*1;
				C(k)=C_K_WP*0;
				C(k)+=C_K_W*0;
				N(k)=N_K_W*(-1);
			}
			else{
				P(k)=P_K_WP*1;
				C(k)=C_K_WP*0;
				C(k)+=C_K_W*(-1);
				N(k)=N_K_W*0;
			}
		}
		//diffusion k
		if(C_FR_k(kp)==0){
			if(C_FR_k(kn)==0){
				P(k)+=P_K_DIFF*0;
				C(k)+=C_K_DIFF*0;
				N(k)+=N_K_DIFF*0;
			}
			else{
				P(k)+=P_K_DIFF*0;
				C(k)+=C_K_DIFF*(-1);
				N(k)+=N_K_DIFF*1;
			}
		}
		else{
			if(C_FR_k(kn)==0){
				P(k)+=P_K_DIFF*1;
				C(k)+=C_K_DIFF*(-1);
				N(k)+=N_K_DIFF*0;
			}
			else{
				P(k)+=P_K_DIFF*1;
				C(k)+=C_K_DIFF*(-2);
				N(k)+=N_K_DIFF*1;
			}
		}
	//---------------------------------------------------------------
#endif///////////////////////////////////////////////////////////////

		}
//-------------------------------------------------------------------------------------------

//---------------------------------Gardons les vitesses--------------------------------------
		b->u_p[g->j]=u;
#ifdef BLOC_DIM_3D
		b->w_p[g->j]=w;
#endif
//-------------------------------------------------------------------------------------------

//----------------Ici on fait une derniere optimization pour l'algo--------------------------
		//Multiplier par la frontiere est tjrs une bonne methode de garantir une bonne
		//robustesse de l'algo.
//		P(j)*=C_FR_j(j);
//		P(i)*=C_FR_i(i);
		C(i)=(C(i)+1.);//*C_FR_i(i); 
//		N(i)*=C_FR_i(i);
//		N(j)*=C_FR_j(j);
//-------------------------------------------------------------------------------------------

#ifdef BLOC_DIM_3D //////////////////////////////////////////////////////////////////////////
//---------------Ici on arranje la verticale pour le calcul implicite------------------------
//						VOIR LE DOCUMENT ThomasAlgorithm
		P(k)=-1.*P(k);//*C_FR_k(k);
		C(k)=(1.-C(k));//*C_FR_k(k);
		N(k)=-1.*N(k);//*C_FR_k(k);
		if(g->k!=0){
			P(k)=P(k)/b->k.c[g->kp][g->i][g->j];
			C(k)=C(k)-P(k)*(b->k.n[g->kp][g->i][g->j]);
		}
//-------------------------------------------------------------------------------------------
#endif //////////////////////////////////////////////////////////////////////////////////////
	}
	}
#ifdef BLOC_DIM_3D
	}
#endif

//-----------------------------------------------------------------------------------------

#ifdef TEST_MASS_ON//////////////////////////////////////////////////////////////////////////
//--------------------------Test de la conservativite 2D du schema----------------------------
#ifdef BLOC_DIM_3D
	for(g->k=0; g->k<t->z.P; g->k++){
		g->kp=g->k-1;
		g->kn=g->k+1;
#endif
	for(g->i=0; g->i<t->x.P; g->i++){
		g->ip=g->i-1;
		g->in=g->i+1;
	for(g->j=0; g->j<t->y.P; g->j++){
		g->jp=g->j-1;
		g->jn=g->j+1;
		
		b->i.c IJ	=
					b->i.n IPJ + b->j.n IJP
				+	b->i.c IJ
				+	b->i.p INJ + b->j.p IJN;
	}
	}
#ifdef BLOC_DIM_3D
	}
#endif
//------------------------------------------------------------------------------------------
#endif//////////////////////////////////////////////////////////////////////////////////////

	return;
}

//********************Libere de memoire les blocs crees par create_blocs.******************
void free_blocs(s_memory_blocs *b, s_all_parameters *t){											//*
//*****************************************************************************************
	BLC_FREE(b->C_old);
	BLC_FREE(b->C_new);
	B_BLC_FREE(b->C_so);
	B_BLC_FREE(b->C_fr);
	BLC_FREE(b->V_u);
	BLC_FREE(b->V_v);
#ifdef BLOC_DIM_3D
	BLC_FREE(b->V_w);
	free(b->k.a-ALL_INC);
	free(b->k.b-ALL_INC);
	BLC_FREE(b->k.p);
	BLC_FREE(b->k.c);
	BLC_FREE(b->k.n);
	free(b->w_p-ALL_INC);
#endif
	free(b->j.a-ALL_INC);
	free(b->j.b-ALL_INC);
	free(b->u_p-ALL_INC);
//	BLC_FREE(b->i.p);
//	BLC_FREE(b->i.c);
//	BLC_FREE(b->i.n);
	BLC_FREE(b->j.p);
//	BLC_FREE(b->j.c);
	BLC_FREE(b->j.n);
	return;
}