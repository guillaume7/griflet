#ifndef PROG_BLC_H
#define PROG_BLC_H

//This defines the increment of size to give each extremity of the domain
//limits for memory allocation
#define ALL_INC 2	

//Ceci definit la difference de taille entre les mailles pour les concentration
//et les mailles pour les frontieres et vitesses selon l'horizontale.
#define B_INC 2 

//Ceci definit la difference de taille entre les mailles de concentration et
//les mailles pour les vitesses selon la verticale.
#define B_K_INC 1 

//Donne la taille de la source en unitesd de bloc de memoire.Faut tester quand c'est 0.
#define STAINSIZE 2 

#define COMP_FILL 1.E29
#define FILLVALUE 1.E34
#define MYFILL	0.

#ifdef BLOC_DIM_3D

#define V_BLC v[k][i][j]
#define FR_BLC fr[k][i][j]

#endif

#ifdef BLOC_DIM_2D

#define V_BLC v[i][j]
#define FR_BLC fr[i][j]

#endif

#ifdef BLOC_DIM_3D

typedef cube_t bloc_t; //Ceci nous pose la dimension
typedef b_cube_t b_bloc_t;

#endif

#ifdef BLOC_DIM_2D

typedef table_t bloc_t; //Ceci nous pose la dimension
typedef b_table_t b_bloc_t;

#endif

#ifdef BLOC_DIM_1D

typedef vecteur_t bloc_t; //Ceci nous pose la dimension
typedef b_vecteur_t b_bloc_t;

#endif

typedef struct numerical_coefficients_blocs{
	vecteur_t a;	//Coeff de l'advection
	vecteur_t b;	//Coeff de la diffusion
	bloc_t p,c,n;	//Coeffs associes a C_ip, C_i et C_in
#ifdef BLOC_DIM_3D
	vecteur_t g;	//Coeff auxiliaire pour le schema implicite.
#endif
}s_numerical_coefficients_blocs;

typedef struct memory_blocs{
	bloc_t C_old, C_new, C_temp;
	b_bloc_t C_so, C_fr;
	bloc_t V_u, V_v;
#ifdef BLOC_DIM_3D //////////////////////////////////////////////////////
	bloc_t V_w;
	s_numerical_coefficients_blocs k;
	vecteur_t w_p; //Coeffs auxiliaires pour le remplissage des coefs P,C,N.
#endif //////////////////////////////////////////////////////////////////
	vecteur_t u_p; //Coeffs auxiliaires pour le remplissage des coefs P,C,N.
	s_numerical_coefficients_blocs j;
	s_numerical_coefficients_blocs i;
}s_memory_blocs;

void create_blocs(s_all_parameters*, s_memory_blocs*);
void fill_stain(s_all_parameters*, s_memory_blocs*);
void fill_adv(s_nc_all_files *, s_all_parameters*, s_memory_blocs*);
void fill_coefs(s_nc_all_files *, s_all_parameters*, s_memory_blocs*);
void cdf_dataread(s_nc_input*, bloc_t, b_bloc_t, s_all_parameters*); //Doit lire les champs de vitesses et les remplir.
void cdf_adv_integration(s_nc_input* c, bloc_t, s_all_parameters* p);			
void free_blocs(s_memory_blocs*, s_all_parameters *);

#endif
