#ifndef PROG_PRM_H
#define PROG_PRM_H

//--Ici on codifie les differents types de schemas numeriques disponibles pour l'utilisateur---
#define SCH_UP 0x01
#define SCH_HY 0x02
#define SCH_DI 0x04
#define SCH_SO 0x08
#define SCH_NOP 0x0F
#define SCH_DEFAULT (0x01|0x04|0x08) //default.
//--------------------------------------------------------------------------------

//--------------Ici c'est les identifications des variables dimension.-----------
#define VX		0
#define VY		1
#define VZ		3
#define VDATE	5
//--------------------------------------------------------------------------------

#define ICOORD 0
#define IDATE  1
#define GAUCHE 0 //pour la struct user.
#define DROITE 1

//Struct faites pour les coeff. de chaque dimensio:
typedef struct dimension_parameters{
	double L;
	double V;
	double T;
	double K;
	double Re;
	double Str;
	index_t N;
	index_t P; //Attention ceci la taille de la maille pour C. Rajouter 1 pour les vitesses!
	index_t D;
	double u; //Cette valeur donne une vitesse uniforme.
	double a;
	double b;
	double tt;
}s_dimension_parameters;

//Structure faite pour les donnees de l'utilisateur.
typedef struct user_parameters{
	bool_t instant;
	bool_t surf;
	bool_t annual;
	bool_t jan;
	s_nc_dimensions_offsets subindL;
	s_nc_dimensions_offsets subindR;
	s_nc_dimensions_offsets soind;
}s_user_parameters;

//Structure pour les parametres numeriques de la source.
typedef struct source_parameters{
	double concentration;
	double coninit;
	index_t i,j,k;
}s_source_parameters;

//Structure de la masse du traceur.
typedef struct mass{
	double leak;	//mass leak value.
	double initial;	//initial mass value.
	double final;	//final mass value.
	double balance; //difference between final and initial mass.
	double volume;	//Total volume of the domain.
}s_mass;

//Structure de touts les parametres.
typedef struct all_parameters{
	char *filename;
	choice_t schema;
	s_user_parameters user;
	s_dimension_parameters x,y,z;
	s_source_parameters so;
	s_mass mass;
}s_all_parameters;

//Initializations des parametres.
size_t ncconvert(index_t, size_t);
void params_init(s_nc_all_files *, s_all_parameters *);
void user_init(s_nc_all_files *, s_all_parameters *);
void f_dimprm_init(int, int, size_t*, size_t*, size_t*, double coefdiff, 
				   s_dimension_parameters*);
void dimprm_init(s_dimension_parameters*, double, double, index_t);
void dimprm_finit(s_dimension_parameters*, index_t, index_t);
double _max(double, double);
void display_init(s_nc_dimension*, s_dimension_parameters*);
double calclength(int, int, size_t*, size_t*, size_t*);
void indexRL_init(s_all_parameters*, bool_t, char*, char*, int, int, size_t, s_nc_dimension*, size_t*, size_t*);
void value2dindex(double, s_nc_dimension*, int, size_t*);
void set_bools(s_user_parameters*, bool_t, bool_t, bool_t, bool_t);
void user_choice(s_user_parameters*, char);

#endif