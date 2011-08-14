/******main de prog_w v0.12a*****************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include <alloc.h>
#include <math.h>
#include <time.h>
#include "prog_ind.h"
#include "prog_boo.h"
#include "prog_all.h"
#include "prog_io.h"
#include "prog_prm.h"
#include "prog_blc.h"
#include "prog_3d.h"
#include "prog_mai.h"
#include "prog_cdl.h"

int main(int argc, char *argv[]){
/*Begin variables.*************************************************/
	clock_t start, end;	//variables du chronometre du temps de calcul.
	s_parameters *p_traceur; //parametres du traceur.
	s_parameters    traceur;
	s_indexes *p_index;
	s_indexes 	 index;// iterateurs
	s_blocs *p_blocs;  //Pointeur des blocs de memoire.
	s_blocs    blocs;	//structure de memoire des donnees de la concentration du traceur.
	char ver[] = THIS_VERSION;
/*End variables and begin code.************************************/
//	nccreate("test.cdf",NC_CLOBBER);
/***********Above is the test if netcdf library works or not********/
	printf("\nProgram prog_w %s\n\n",ver); //Affiche la version du programe.
	if(argc<2) return 1;		//Teste si l'utilisateur a donne un nom de fichier.
	p_index = &index;    	//Associe les pointeurs aux variables.
	p_traceur = &traceur;   //Idem.
	p_blocs = &blocs;			//Idem ibidem.
	//Demande a l'utilisateur de choisir un schema numerique.
	prompt_user(p_traceur);
	//Initialise les valeurs des parametres et affiche leurs valeurs.
	traceur.filename = argv[1];
	initialiser(p_traceur);
	//Redefinit les dimensions I,J et K a partir du fichier de lecture.
	cdl_getatt(p_traceur, &(p_traceur->cdl_u));
	cdl_getatt(p_traceur, &(p_traceur->cdl_v));
	/*Allocation en memoire puis remplissage des conditions initiales*/
	create_blocs( p_traceur, p_blocs );
	fill_adv(p_traceur, p_blocs);
	/*Creation et initialisation d'un nouveau fichier cdl*/
	cdl_new(p_traceur, p_blocs);
	/*Calcul par la methode des elements finis base sur le memoire
		de Deleersnijder sur le detroit de Bering*/
	printf("\nIterating ");
	start = clock();
	calcule( p_index, p_traceur, p_blocs);
	end = clock();
	printf(" Done.\n");
	printf("The time was %6.3f seconds.\n",(end-start)/CLK_TCK);
	cdl_close(traceur.filename);
	free_blocs(p_blocs, p_traceur);
	return 0;
}

//Fonction qui demande a l'utilisateur quel schema employer.
void prompt_user(s_parameters *t){
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
	readint(&hec);
	printf("\n");
	switch(hec){
	case 0:	t->schema = SCH_UP; break;
	case 1:	t->schema = SCH_HY; break;
	case 2:	t->schema = SCH_DI; break;
	case 3:	t->schema = SCH_SO; break; //Pas encore disponible.
	case 4:	t->schema = SCH_HY | SCH_DI; break;
	case 5:	t->schema = SCH_UP | SCH_DI; break;
	case 6:	t->schema = SCH_HY | SCH_DI | SCH_SO; break;
	case 7:	t->schema = SCH_DEFAULT; break;
	default:	t->schema = SCH_DEFAULT; break;
	}
	printf("Votre choix est le %X.\n\n", t->schema);
	return;
}
