// msnemo.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"

//*****************************************************************************************
//main de prog_w v0.14
int main(int argc, char *argv[]){
//*****************************************************************************************
#ifdef TEST_FILE_ON
	FILE* file;
#endif
//-Begin variables.------------------------------------------------------------------------
	clock_t start, finish;
	s_all_parameters *traceur_p; //parametres du traceur.
	s_all_parameters    traceur;
	s_indexes *index_p;
	s_indexes 	 index;//iterateurs.
	s_memory_blocs *blocs_p;  //Pointeur des blocs de memoire.
	s_memory_blocs    blocs;  //structure de memoire des donnees de la concentration du traceur.
	s_nc_all_files	courants;
	s_nc_all_files *courants_p;
	char ver[] = THIS_VERSION;
//-------------------End variables and begin code.-----------------------------------------
	printf("\nProgram prog_w %s\n\n",ver); //Affiche la version du programe.
	if(argc<ARGN) return 1;		//Teste si l'utilisateur a donne un nom de fichier.
	index_p = &index;    	//Associe les pointeurs aux variables.
	traceur_p = &traceur;   //Idem.
	blocs_p = &blocs;		//Idem ibidem.
	courants_p = &courants; //Idem.
	courants.u.file.name_p=argv[ARG_U]; //Ceci est pour quand on emploit la command line.
	courants.v.file.name_p=argv[ARG_V];
	courants.w.file.name_p=argv[ARG_W];
	traceur.filename = argv[ARG_OUT];
	courants.topo.file.name_p = argv[ARG_TOPO];

	//Definit le choix de l'utilisateur:
	user_choice(&(traceur_p->user), *(argv[ARG_USER]));

	//Initialise ma filese sur les fichiers netcdf.
	ncfiles_init(courants_p);

	//Initialise les parametres.
	params_init(courants_p, traceur_p);//Semble ok, mais il faut mieux tester...

	//Allocation en memoire puis remplissage des conditions initiales
	create_blocs(traceur_p, blocs_p); 
	fill_stain(traceur_p, blocs_p);
	fill_adv(courants_p, traceur_p, blocs_p);

	//Remplissage des coeffs numeriques. Detruit les blocs U,V et W.
	fill_coefs(courants_p, traceur_p, blocs_p);

	//Creation et initialisation d'un nouveau fichier cdf
	cdf_new(courants_p, traceur_p, blocs_p); 

	//Ferme mes fichiers netcdf de input.
	ncfiles_close(courants_p);

	//Calculons la masse initiale du traceur.
	traceur_p->mass.initial=mass_calculation(traceur_p, blocs_p);
	printf("\nThe initial total mass is %f units\n", traceur_p->mass.initial);

	//Calcul par la methode des differences finies base sur le memoire
	//de Deleersnijder sur le detroit de Bering
	start=clock();
#ifdef CALCSWITCH_ON
	printf("\nIterating ");
	calcule( index_p, traceur_p, &(courants_p->out), blocs_p);
	printf(" Done.\n");
#endif
	finish=clock();
	printf("\nThe total time was %3.3f seconds\n", (float)(finish-start)/CLOCKS_PER_SEC);

	//Calcul qui verifie la conservation de la masse.
	traceur_p->mass.final=mass_calculation(traceur_p, blocs_p);
	printf("The final total mass is %f units\n", traceur_p->mass.final);

	//Affiche le terme de leaking et le bilan de masse.
	printf("The mass leak is %f units\n", traceur_p->mass.leak);
	printf("The balance is %f units\n", traceur_p->mass.initial-traceur_p->mass.leak-traceur_p->mass.final);
	cdf_close(&(courants_p->out.file));
#ifdef TEST_FILE_ON
//---------------Testing fprintf values------------------------------------------------------
//--------------Testing les vecteurs des a et b pour j et k-------
	file=fopen("test.cdl","w");
#ifdef BLOC_DIM_3D
	for(index.i=0;index.i<traceur.z.P;index.i++){
		fprintf(file,"%1.1e ",blocs_p->k.a[index.i]);
	}
	fprintf(file,"\n");
	for(index.i=0;index.i<traceur.z.P;index.i++){
		fprintf(file,"%1.1e ",blocs_p->k.b[index.i]);
	}
	fprintf(file,"\n");
#endif
	for(index.i=0;index.i<traceur.y.P;index.i++){
		fprintf(file,"%1.1e ",blocs_p->j.a[index.i]);
	}
	fprintf(file,"\n");
	for(index.i=0;index.i<traceur.y.P;index.i++){
		fprintf(file,"%1.1e ",blocs_p->j.b[index.i]);
	}
	fprintf(file,"\n\n");
//-----------------------------------------------------------------
//--------------Testing les blocs des n,c,p pour k-------
	index.k=3;
	for(index.i=0;index.i<traceur.x.P;index.i++){
	for(index.j=0;index.j<traceur.y.P;index.j++){
		fprintf(file,"%1.1e ",B_K(p));;
	}
	fprintf(file,"\n");
	}
	fprintf(file,"\n\n");
	index.k=3;
	for(index.i=0;index.i<traceur.x.P;index.i++){
	for(index.j=0;index.j<traceur.y.P;index.j++){
		fprintf(file,"%1.1e ",B_K(c));
	}
	fprintf(file,"\n");
	}
#ifdef BLOC_DIM_3D
	fprintf(file,"\n\n");
	index.k=3;
	for(index.i=0;index.i<traceur.x.P;index.i++){
	for(index.j=0;index.j<traceur.y.P;index.j++){
		fprintf(file,"%1.1e ",B_K(n));
	}
	fprintf(file,"\n");
	}
#endif
//-----------------------------------------------------------------
	fclose(file);
//-------------------------------------------------------------------------------------------
#endif
	free_blocs(blocs_p, traceur_p);
	return 0;
}
