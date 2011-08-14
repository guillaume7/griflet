#ifndef PROG_SWITCHES_H
#define PROG_SWITCHES_H

//----------Ici on centralise les switchs utiles pour tester ce programme--------
//Switch YEAR_96_ON/OFF: switch required to activate for the year 96.
#define YEAR_90_OFF
#define YEAR_96_OFF //C'est pour w.cdf

//BLOC_DIM_3D/2D Ici on choisit soit en 3D, soit en 2D
#define BLOC_DIM_2D 

//AUTO soit MANUAL pour l'input des donnees.
#define AUTO

//UN_AN ou DIX_ANS: Ceci donne une annee de calculs ou dix annees.
#define DIX_ANS

//POINTSOURCE_ON or _OFF: definit si la source est un point ou une tache.
#define POINTSOURCE_ON 

//Ceci active/desactive les calculs de concentration.
#define CALCSWITCH_ON

//Ceci active/desactive des cellules a volumes constants.
#define VOLUME_FIXE_ON

//LEAK_CALC_OFF/_ON pour le calcul des fuites de masse.
#define LEAK_CALC_OFF 

//ONLY_FLOATS ou bien DOUBLES_ALLOWED. Ca permet de sauver de la place en memoire
//seulement on perd de la precison dans les calculs.
#define ONLY_FLOATS 

//ANNUAL_MEAN_ON/OFF . Ca choisit entre faire la moyenne annuelle
//des vitesses ou bien prendre la moyenne mensuelle des vitesses.
/****************************/
#define ANNUAL_MEAN_ON  //ICI!
/****************************/

//INSTANT_ON/OFF. Instant or gradual release.
/************************/
#define INSTANT_ON //ICI!
/************************/

#ifdef CALCSWITCH_OFF
#define TEST_FILE_OFF  //Ceci dit si l'on doit creer un fichier ascii qui teste les blocs.
#ifdef BLOC_DIM_3D
#define TEST_MASS_OFF	//Ceci teste dans V la conservativite de la masse des coefs.
#endif
#endif
//--------------------------------------------------------------------------------

//----------Ici on centralise les donnees de input du programme--------
#define U_CDF "98_u.cdf"
#define V_CDF "98_v.cdf"
#define W_CDF "98_w.cdf"
#define OUT_CDF "out.cdf"
//--------------------------------------------------------------------------------

//------Ici on definit les parametres physiques-----------------------------------

#define WATER 1
#define LAND 0

#define KARST 400.
#define SURF 5.

////////////////
#define JAN	1
#define FEV	32
#define MAR	60
#define ABR	91
#define MAI	121
#define JUN	152
#define JUL	182
#define AGO	213
#define SET	244
#define OUT	274
#define NOV	305
#define DEZ	335
////////////////
#ifdef ANNUAL_MEAN_ON
#define MEAN 12
#define DATE JAN
#else 
#define MEAN 1
/************************/
#define DATE JUL   //ICI!
/************************/
#endif

/************************/
#define DEPOP KARST //ICI!
/************************/

#ifdef INSTANT_ON
#define INITIALCOND 1. 
#else
#define INITIALCOND 0. 
#endif

#define SOURCE_TERM 1.
#define COEFDIFF_H 1.0E1   //m^2/s (HE utilisaient 10m^2/s)
#define COEFDIFF_V 1.0E0
#define LONGUEUR	111120.0 //Longueur d'un degre em metres:
#define PROFONDEUR 1.E4   //grandeur caracteristique en metres.

#ifdef DIX_ANS
#define TEMPS	3.1104E8 //grandeur caracteristique en secondes.
#endif

#ifdef UN_AN
#define TEMPS	3.1104E7 //grandeur caracteristique en secondes.
#endif

#define VITESSE	1.E-2 //grandeur caracteristique en m/s ce qui donne une unite de cm/s.
#define V_UNIFORM 5. //cm/s c'est la vitesse uniforme si on ne prend pas les champs du GFDL.

//epsilon, valeur a partir de laquelle on considere zero pour les concentrations.
#define EPS	1.E-6	

//--------------------------------------------------------------------------------

//------------Ici on definit les donnees du mode AUTO-----------------------------

#define HEC		7

//Si c'est le mode auto alors ici sont definit les valeurs par defaut
//Upwind	0
//Hybride	1
//Diffusion 2
//Source	3
//HD		4
//UD		5
//HDS		6
//UDS		7

#define LON_L	450.
#define LON_R	300.
#define LAT_L	-55.
#define LAT_R	25.
#define DEP_L	DEPOP
#define DEP_R	50. //Ce param donne des problemes...
#define DAT_T	DATE	//Inconnue.
#define SOLON	221.    //139ºW = 221ºE
#define SOLAT	-21.75  //21º50'S
#define SODEP	5.

#ifdef DIX_ANS

#define ITE_N	8001 //Valeur a partir de laquelle je n'ai pas de over-shooting.
#define ITE_D	200

#endif

#ifdef UN_AN

#define ITE_N	801 //Valeur a partir de laquelle je n'ai pas de over-shooting.
#define ITE_D	20

#endif
//--------------------------------------------------------------------------------


#endif