//******parametres de prog_w v0.7*****************
#include "stdafx.h"

#define DIMPRM_INIT(q,r,s) 	f_dimprm_init(k->u.file.ncid, k->u.q.varid, p->user.subindL.r, p->user.subindR.r, &(k->u.q.length), s, &(p->q));

//*************************************************************************************
void params_init(s_nc_all_files *k, s_all_parameters *p){
//*************************************************************************************
	index_t aux1, aux2;
	//Ici on definit le schema numerique.
	index_t hec;
	printf("Code pour le schema numerique\n");
	printf("0 == schema Upwind (Deleersnijder).\n");
	printf("1 == schema Hybride (I.D.James 86).\n");
	printf("2 == schema pour la diffusion horizontale (explicite)(Deleersnijder).\n");
	printf("3 == Schema source/puit (Deleersnijder).\n");
	printf("4 == Schema hybride + diffusion.\n");
	printf("5 == Schema upwind + diffusion.\n");
	printf("6 == Schema hybride + diffusion + source.\n");
	printf("7 == Schema upwind + diffusion + source.\n");
	printf("Choisissez un schema: ");
#ifdef MANUAL
	readint(&hec);
#endif
#ifdef AUTO
	hec=HEC;
#endif
	printf("\n");
	switch(hec){
	case 0:	p->schema = SCH_UP; break;
	case 1:	p->schema = SCH_HY; break;
	case 2:	p->schema = SCH_DI; break;
	case 3:	p->schema = SCH_SO; break; //Pas encore disponible.
	case 4:	p->schema = SCH_HY | SCH_DI; break;
	case 5:	p->schema = SCH_UP | SCH_DI; break;
	case 6:	p->schema = SCH_HY | SCH_DI | SCH_SO; break;
	case 7:	p->schema = SCH_DEFAULT; break;
	default:	p->schema = SCH_DEFAULT; break;
	}
	printf("Votre choix est le %X.\n\n", p->schema);
	//Fin de definition du schema numerique.
	//Choix de l'utilisateur quant au subset et quant aux coord. de la source dans une maille-T.
	user_init(k,p);
	//Manque definir les x.P, y.P et z.P et TOUT le reste. Ici...
	DIMPRM_INIT(x, lon_p, COEFDIFF_H)
	DIMPRM_INIT(y, lat_p, COEFDIFF_H)
	DIMPRM_INIT(z, depth_p, COEFDIFF_V)
	//Prompt a l'utilisateur pour le N.
	aux1=_max(p->x.P/p->x.Str,_max(p->y.P/p->y.Str,p->z.P/p->z.Str));
	printf("\nInserez le nombre d'iterations >> %d: ", aux1);
#ifdef MANUAL
	readint( &(aux1) );
#endif
#ifdef AUTO
	aux1=ITE_N;
#endif
	aux2 = aux1+1;
	while(aux2 > aux1-1){
		printf("Inserez l'increment pour des resultats touts les [0, %d]: ", aux1-1);
#ifdef MANUAL
		readint( &(aux2));
#endif
#ifdef AUTO
		aux2=ITE_D;
#endif
	}
	dimprm_finit(&(p->x), aux1, aux2);
	dimprm_finit(&(p->y), aux1, aux2);
	dimprm_finit(&(p->z), aux1, aux2);
	//Ici c'est juste pour initialiser le terme du calcul des fuites de traceur.
	p->mass.leak=0.0;
	//Il manque quand meme definir la concentration initiale ainsi que les indexes numeriques.
	//Attention ces indexes sont ceux des U-cells, il faut convertir en T-cells.
	p->so.concentration=SOURCE_TERM;
	p->x.tt*=p->so.concentration;
	p->y.tt*=p->so.concentration;
	p->z.tt*=p->so.concentration;
	if(p->user.instant == ON)	p->so.coninit=1.;
	else						p->so.coninit=0.;
	p->so.i=(ncconvert(*p->user.soind.lon_p, *p->user.subindL.lon_p)+k->u.x.length)%k->u.x.length; //Je rajoute +1 au modulo pour l'avoir dans les vitesses.
	p->so.j=ncconvert(*p->user.soind.lat_p, *p->user.subindL.lat_p);
	p->so.k=ncconvert(*p->user.soind.depth_p, *p->user.subindL.depth_p);
	//Print les parametres numeriques de la simulation.
	printf("Fichier: %s\n", p->filename);
	display_init(&(k->u.x), &(p->x));
	display_init(&(k->u.y), &(p->y));
	display_init(&(k->u.z), &(p->z));
	printf("vitesse uniforme u, v et w: %2.3f\n", p->x.u);
	return;
}

//*************************************************************************************
//Fonction qui convertit les indices netcdf en indices du calcul numerique maille U!.
index_t ncconvert(index_t index, size_t indL){
//*************************************************************************************
	//Attention: ici +1 ????? A verifier.
	return (int)(index-indL);
}

//*************************************************************************************
//Imprime a l'ecran les choix de l'utilisateur et les valeurs numeriques.
void display_init(s_nc_dimension *x_p, s_dimension_parameters *prm_p){
//*************************************************************************************
	printf("\nDimension %s:\n", x_p->name_p);
	printf("L %.1e\tV %.1e\tT %.1e\n", prm_p->L, prm_p->V, prm_p->T);
	printf("Str %.1e\tRe %.1e\n", prm_p->Str, prm_p->Re);
	printf("D-size %d\n", prm_p->P);
	printf("numerical: a=%f\tb=%f\n", prm_p->a, prm_p->b);
	return;
}

//*************************************************************************************
//Compare deux entrees et rend la valeur maximum.
double _max(double one, double two){
//*************************************************************************************
	if(one<two) one=two;
	return one;
}

//*************************************************************************************
//Calcule l'ensemble qui permet d'initialiser les parametres physiques et meme quelques numeriques.
void f_dimprm_init(int ncid, int varid, size_t* iL_p, size_t* iR_p, size_t* ilength_p, double coefdiff, s_dimension_parameters* x_p){
//*************************************************************************************
	double size;
	index_t nsize;
	size=calclength(ncid, varid, iL_p, iR_p, ilength_p);
	nsize=(ncconvert(*(iR_p),*(iL_p))+*(ilength_p))%*(ilength_p);
	dimprm_init(x_p, coefdiff, size, nsize);
	return;
}

//*************************************************************************************
//Calcule la longueur caracteristique pour chaque dimension du sous-domaine.
double calclength(int ncid, int varid, size_t* iL_p, size_t* iR_p, size_t* length_p){
//*************************************************************************************
	double aux1, aux2;
	size_t first=0;
	size_t last=*length_p-1;
	NC_GET_VAR1(ncid, varid, iL_p, &aux1);
	NC_GET_VAR1(ncid, varid, iR_p, &aux2);
	aux1=aux2-aux1;
	// Il faut faire un espece de modulo 360 en reels.
	if(aux1<0){ 
		NC_GET_VAR1(ncid, varid, &(last), &aux2);
		aux1+=aux2;
		NC_GET_VAR1(ncid, varid, &(first), &aux2);
		aux1-=aux2;
	}
	return aux1;
}

//*************************************************************************************
//Initialise les parametres physiques, et meme quelques numeriques (pour chaque dimension).
void dimprm_init(s_dimension_parameters *x, double diffcoef, double length, index_t nlength){
//*************************************************************************************
	x->K=diffcoef;
	x->L=length*LONGUEUR;
	x->V=VITESSE;
	x->T=TEMPS;
	x->Str=x->L/x->T/x->V;
	x->Re=x->K*x->T/x->L/x->L;
	x->P=nlength-1; //Attention: ceci donne la correction pour la vraie taille de la maille des concentrations.
	x->u=V_UNIFORM;
	return;
}

//*************************************************************************************
//Finit d'initialiser touts les parametres numeriques (pour chaque dimension).
void dimprm_finit(s_dimension_parameters *x, index_t time, index_t timeinc){
//*************************************************************************************
	x->N=time;
	x->D=timeinc;
	x->tt=1./x->N;  //Tu veux juste diviser ta concentration par le nombre d'iterations...
	x->a=x->P/x->Str/x->N; //Coeff 0.5 ou pas de coeff 0.5?
	x->b=x->Re*x->P*x->P/x->N;
	return;
}

//*************************************************************************************
//Definit le sous-domaine donne par l'utilisateur, ainsi que la source.
void user_init(s_nc_all_files *k, s_all_parameters *p){
//*************************************************************************************
	char* textlon1_p="Longitude gauche";
	char* textlon2_p="Longitude droite";
	char* textlat1_p="Latitude S";
	char* textlat2_p="Latitude N";
	char* textdepth1_p="Donner la profondeur du haut (m)";
	char* textdepth2_p="Donner la profondeur du bas(m)";
	char* textdate_p="Donner la date (jours)";
	char* textsolon_p="Donner la longitude de votre source";
	char* textsolat_p="Donner la latitude de votre source";
	char* textsodepth_p="Donner la profondeur de votre source";
	//Definir les bords.
	printf("Choisissez votre region:\n");
	//Definit les indexes de user.subindL et R (i.e. lon,lat,depth,date).
	indexRL_init(p, ICOORD, textlon1_p, textlon2_p, k->w.file.ncid, k->w.x.varid, k->w.x.length, &(k->w.x), p->user.subindL.lon_p, p->user.subindR.lon_p);
	indexRL_init(p, ICOORD, textlat1_p, textlat2_p, k->w.file.ncid, k->w.y.varid, k->w.y.length, &(k->w.y), p->user.subindL.lat_p, p->user.subindR.lat_p);
	indexRL_init(p, ICOORD, textdepth1_p, textdepth2_p, k->u.file.ncid, k->u.z.varid, k->u.z.length, &(k->u.z), p->user.subindL.depth_p, p->user.subindR.depth_p);
	indexRL_init(p, IDATE, textdate_p, NULL, k->u.file.ncid, k->u.date.varid, k->u.date.length, &(k->u.date), p->user.subindL.date_p, p->user.subindR.date_p);
	//Definit les indexes de user.soind (i.e. les coord de la source)
	indexRL_init(p, IDATE, textsolon_p, NULL, k->w.file.ncid, k->w.x.varid, k->w.x.length, &(k->w.x), p->user.soind.lon_p, NULL);
	indexRL_init(p, IDATE, textsolat_p, NULL, k->w.file.ncid, k->w.y.varid, k->w.y.length, &(k->w.y), p->user.soind.lat_p, NULL);
	indexRL_init(p, IDATE, textsodepth_p, NULL, k->u.file.ncid, k->u.z.varid, k->u.z.length, &(k->u.z), p->user.soind.depth_p, NULL);
	return;
}

//*************************************************************************************
//Execute la routine qui determine les valeurs des indexes R et L des coord (lon, lat, depth, date) du sous-domaine.
//Soit ICOORD soit IDATE
void indexRL_init(s_all_parameters* p_p,bool_t boo, char* text1, char* text2, int ncid, int varid, size_t length, s_nc_dimension* d_p, size_t* iL_p, size_t* iR_p){
//*************************************************************************************
	double aux1, aux2, aux3;
	size_t first=0;
	length=length-1;
	NC_GET_VAR1(ncid, varid, &(first), &aux1); //prendre les limites des longitudes.
	NC_GET_VAR1(ncid, varid, &(length),&aux2); //prendre les limites des longitudes.
	printf("\n%s[%2.3f,%2.3f]: ", text1, aux1, aux2);
#ifdef MANUAL
	readfloat(&aux3); //Convertir ceci en indexp pour la dim x. C'est le plus simple.
#endif
#ifdef AUTO
	if(boo==ICOORD){
		switch(varid){
			case VX:	aux3=LON_L;break;
			case VY:	aux3=LAT_L;break;
			case VZ:	if(p_p->user.surf == ON) aux3=SURF; 
						else aux3=KARST; 
						break;
			default:	aux3=1.;break;	
		}
	}
	else{
		switch(varid){
			case VDATE:	if(p_p->user.jan == ON) aux3=aux1+JAN;
						else aux3=aux1+JUL;
						break;
			case VX: aux3=SOLON;break;
			case VY: aux3=SOLAT;break;
			case VZ: aux3=SODEP;break;
			default: aux3=1.;break;
		}
	}
#endif
	value2dindex(aux3, d_p, ncid, iL_p);
	if(boo==ICOORD){
		printf("\n%s[%2.3f,%2.3f]: ", text2, aux1, aux2);
#ifdef MANUAL
		readfloat(&aux3); //Convertir ceci en indexp pour la dim x. C'est le plus simple.
#endif
#ifdef AUTO
		switch(varid){
			case VX:	aux3=LON_R;break;
			case VY:	aux3=LAT_R;break;
			case VZ:	aux3=DEP_R;break;
			default:	aux3=2.;break;	
		}
#endif

		value2dindex(aux3, d_p, ncid, iR_p);
		NC_GET_VAR1(ncid, d_p->varid, iL_p, &aux1);
		NC_GET_VAR1(ncid, d_p->varid, iR_p, &aux2);
		printf("\nVous avez choisi les coordonnees %2.3f et %2.3f", aux1, aux2);
	}
	else{
		NC_GET_VAR1(ncid, d_p->varid, iL_p, &aux1);
		printf("\nVous avez choisi la coordonnee %2.3f", aux1);
	}
	return;
}

//*************************************************************************************
//Va chercher l'index de la dimension qui est le plus proche de la valeur donnee.
//Ca sert pour convertir la valeur de la coordonnee de l'utilisateur en index_p de la var_dim.
//Cette fonction bugge pour les dates. Il faut soustraire 1 dans le code plus en aval...
void value2dindex(double userval, s_nc_dimension* d, int ncid, size_t* ind_p){
//*************************************************************************************
	size_t i;
	double prev,next;
	next=userval-1;;
	for(i=0;i<d->length && userval>next;i++) NC_GET_VAR1(ncid, d->varid,  &i,&next); 
	i=i-1;
	NC_GET_VAR1(ncid, d->varid, &i, &prev);
	if(fabs(next-userval)<fabs(prev-userval)) i++;
	*ind_p=i; 
	return;
}

//*************************************************************************************
void set_bools(s_user_parameters* p_p, bool_t one, bool_t two, bool_t three, bool_t four){
//*************************************************************************************
	p_p->instant = one;
	p_p->surf = two;
	p_p->annual = three;
	p_p->jan = four;
	printf("\nUser's choice [inst surf annual jan]: [%d %d %d %d]\n\n", p_p->instant, p_p->surf, p_p->annual, p_p->jan);
	return;
}

//*************************************************************************************
void user_choice(s_user_parameters* p_p, char c){
//*************************************************************************************
	switch(c){
	case 'a': set_bools(p_p, ON, ON, OFF, ON);	break;
	case 'b': set_bools(p_p, ON, ON, OFF, OFF);	break;
	case 'c': set_bools(p_p, ON, ON, ON, ON);	break;
	case 'd': set_bools(p_p, ON, OFF, OFF, ON);	break;
	case 'e': set_bools(p_p, ON, OFF, OFF, OFF); break;
	case 'f': set_bools(p_p, ON, OFF, ON, ON);	break;
	case 'g': set_bools(p_p, OFF, ON, OFF, ON);	break;
	case 'h': set_bools(p_p, OFF, ON, OFF, OFF);	break;
	case 'i': set_bools(p_p, OFF, ON, ON, ON);	break;
	case 'j': set_bools(p_p, OFF, OFF, OFF, ON);	break;
	case 'k': set_bools(p_p, OFF, OFF, OFF, OFF); break;
	case 'l': set_bools(p_p, OFF, OFF, ON, ON);	break;
	default:  set_bools(p_p, OFF, ON, OFF, ON);	break;
	}
	return;
}

/*
a - INST SURF VAR JAN
b - INST SURF VAR JUL
c - INST SURF MEAN JAN
d - INST KARST VAR JAN
e - INST KARST VAR JUL
f - INST KARST MEAN JAN
g - GRAD SURF VAR JAN
h - GRAD SURF VAR JUL
i - GRAD SURF MEAN JAN
j - GRAD KARST VAR JAN
k - GRAD KARST VAR JUL
l - GRAD KARST MEAN JAN
*/

