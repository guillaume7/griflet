/**************fonction allocation en memoire************/
#include "stdafx.h"

//*************************************************************************************
// Alloue en memoire (BB AAA BB) ou #BB==p et #AAA==N et rend le pointeur
// vers (AAA) apres avoir tout remplit de zeros.
vecteur_t array_alloc( index_t N, unsigned short int p){
//*************************************************************************************
	index_t i;
	double begin;
	vecteur_t vecteur;
	begin = 0;
	if( (vecteur = (double*) malloc( sizeof(double)*(N + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: array malloc failed");
		exit(EXIT_FAILURE);
	}
	for(i=0; i<(N+2*p); i++) vecteur[i] = begin;
	return  ( vecteur + p );
}

//*************************************************************************************
table_t table_alloc(index_t I, index_t J, unsigned short int p){
//*************************************************************************************
	index_t i,j;
	double begin;
	vecteur_t vecteur;
	table_t table;
	begin = 0;
	if( (table = (double**) malloc( sizeof(vecteur_t)*(I + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: (double *) Malloc failed");
		exit(EXIT_FAILURE);
	}
	for(i=0;i<(I+2*p);i++){
		if( (vecteur = (double*) malloc(sizeof(double)*(J + 2*p)))==NULL){
			j = (int) i*(I+2*p);
				fprintf(stderr,"ERROR: double Malloc failed\n i = %u\n i*j = %u\n kilobytes = %9.3f kb", i, j, 1.*j/1024.*sizeof(double));
			exit(EXIT_FAILURE);
		}
		for(j=0; j<(J+2*p); j++) vecteur[j] = begin;
		table[i] = vecteur + p;
	}
	return table + p;
}

//*************************************************************************************
void table_free(table_t table, index_t I, unsigned short int p){
//*************************************************************************************
	index_t i;
	vecteur_t vecteur;
	for(i=0;i<(I+2*p);i++){
		vecteur = (table-p)[i] - p;
		free(vecteur);
	}
	free(table-p);
	return;
}

//*************************************************************************************
cube_t cube_alloc(index_t K, index_t I, index_t J, unsigned short int p){
//*************************************************************************************
	index_t k;
	cube_t cube;
	if( (cube = (cube_t) malloc( sizeof(cube_t)*(K + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: (cube_t) Malloc failed");
		exit(EXIT_FAILURE);
	}
	for(k=0;k<(K+2*p);k++){
		cube[k] = table_alloc(I,J,p);
	}
	return cube + p;
}

//*************************************************************************************
void cube_free(cube_t cube, index_t K, index_t I, unsigned short int p){
//*************************************************************************************
	index_t k;
	table_t table;
	for(k=0;k<(K+2*p);k++){
		table = (cube-p)[k];
		table_free(table, I, p);
	}
	free(cube-p);
	return;
}


//Fonctions qui incrementent ou decrementent le pointeur de base des blocs
//de memoire alloues (vecteurs, tables ou cubes).

//*************************************************************************************
void dec_array(vecteur_t *x){
//*************************************************************************************
	*x-=1;
	return;
}

//*************************************************************************************
void inc_array(vecteur_t *x){
//*************************************************************************************
	*x+=1;
	return;
}

//*************************************************************************************
void dec_table(index_t I, table_t *x){
//*************************************************************************************
	index_t i;
	*x-=1;
	for(i=0;i<I+2;i++) dec_array(*x+i);
	return;
}

//*************************************************************************************
void inc_table(index_t I, table_t *x){
//*************************************************************************************
	index_t i;
	for(i=0;i<I+2;i++) inc_array(*x+i);
	*x+=1;
	return;
}

//*************************************************************************************
void dec_cube(index_t K, index_t I, cube_t *x){
//*************************************************************************************
	index_t k;
	*x-=1;
	for(k=0;k<K+2;k++) dec_table(I, *x+k);
	return;
}

//*************************************************************************************
void inc_cube(index_t K, index_t I, cube_t *x){
//*************************************************************************************
	index_t k;
	for(k=0;k<K+2;k++) inc_table(I, *x+k);
	*x+=1;
	return;
}

/*************************************************************************/
// Alloue en memoire (BB AAA BB) ou #BB==p et #AAA==N et rend le pointeur
// vers (AAA) apres avoir tout remplit de zeros.

//*************************************************************************************
b_vecteur_t b_array_alloc( index_t N, unsigned short int p){
//*************************************************************************************
	index_t i;
	bool_t begin;
	b_vecteur_t vecteur;
	begin = FALSE;
	if( (vecteur = (bool_t*) malloc( sizeof(bool_t)*(N + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: array malloc failed");
		exit(EXIT_FAILURE);
	}
	for(i=0; i<(N+2*p); i++) vecteur[i] = begin;
	return  ( vecteur + p );
}

//*************************************************************************************
b_table_t b_table_alloc(index_t I, index_t J, unsigned short int p){
//*************************************************************************************
	index_t i,j;
	bool_t begin;
	b_vecteur_t vecteur;
	b_table_t table;
	begin = FALSE;
	if( (table = (b_vecteur_t*) malloc( sizeof(b_vecteur_t)*(I + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: (bool_t *) Malloc failed");
		exit(EXIT_FAILURE);
	}
	for(i=0;i<(I+2*p);i++){
		if( (vecteur = (bool_t*) malloc(sizeof(bool_t)*(J + 2*p)))==NULL){
			j = (int) i*(I+2*p);
			fprintf(stderr,"ERROR: bool_t Malloc failed\n i = %u\n i*j = %u\n kilobytes = %9.3f kb", i, j, 1.*j/1024.*sizeof(bool_t));
			exit(EXIT_FAILURE);
		}
		for(j=0; j<(J+2*p); j++) vecteur[j] = begin;
		table[i] = vecteur + p;
	}
	return table + p;
}

//*************************************************************************************
void b_table_free(b_table_t table, index_t N, unsigned short int p){
//*************************************************************************************
	index_t i;
	b_vecteur_t vecteur;
	for(i=0;i<(N+2*p);i++){
		vecteur = (table-p)[i] - p;
		free(vecteur);
	}
	free(table-p);
	return;
}

//*************************************************************************************
b_cube_t b_cube_alloc(index_t K, index_t I, index_t J, unsigned short int p){
//*************************************************************************************
	index_t k;
	b_cube_t cube;
	if( (cube = (b_cube_t) malloc( sizeof(b_cube_t)*(K + 2*p) ))==NULL ){
		fprintf(stderr,"ERROR: (b_cube_t) Malloc failed");
		exit(EXIT_FAILURE);
	}
	for(k=0;k<(K+2*p);k++){
		cube[k] = b_table_alloc(I,J,p);
	}
	return cube + p;
}

//*************************************************************************************
void b_cube_free(b_cube_t cube, index_t K, index_t I, unsigned short int p){
//*************************************************************************************
	index_t k;
	b_table_t table;
	for(k=0;k<(K+2*p);k++){
		table = (cube-p)[k];
		b_table_free(table, I, p);
	}
	free(cube-p);
	return;
}

//Fonctions qui incrementent ou decrementent le pointeur de base des blocs
//de memoire alloues (vecteurs, tables ou cubes).

//*************************************************************************************
void b_dec_array(b_vecteur_t *x){
//*************************************************************************************
	*x-=1;
	return;
}

//*************************************************************************************
void b_inc_array(b_vecteur_t *x){
//*************************************************************************************
	*x+=1;
	return;
}

//*************************************************************************************
void b_dec_table(index_t I, b_table_t *x){
//*************************************************************************************
	index_t i;
	*x-=1;
	for(i=0;i<I+2;i++) b_dec_array(*x+i);
	return;
}

//*************************************************************************************
void b_inc_table(index_t I, b_table_t *x){
//*************************************************************************************
	index_t i;
	for(i=0;i<I+2;i++) b_inc_array(*x+i);
	*x+=1;
	return;
}

//*************************************************************************************
void b_dec_cube(index_t K, index_t I, b_cube_t *x){
//*************************************************************************************
	index_t k;
	*x-=1;
	for(k=0;k<K+2;k++) b_dec_table(I, *x+k);
	return;
}

//*************************************************************************************
void b_inc_cube(index_t K, index_t I, b_cube_t *x){
//*************************************************************************************
	index_t k;
	for(k=0;k<K+2;k++) b_inc_table(I, *x+k);
	*x+=1;
	return;
}

//Fonctions qui remplissent les blocs avec une valeur voulue.

//*************************************************************************************
void fill_array(vecteur_t *x, index_t I, double value){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		*x[i]=value;
	}
	return;
}

//*************************************************************************************
void fill_table(table_t *x, index_t I, index_t J, double value){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		fill_array(*x+i,J,value);
	}
	return;
}

//*************************************************************************************
void fill_cube(cube_t *x, index_t I, index_t J, index_t K, double value){
//*************************************************************************************
	index_t k;
	for(k=0;k<K;k++){
		fill_table(*x+k,I,J,value);
	}
	return;
}

//Fonctions qui remettent à zero les bords des blocs.

//*************************************************************************************
void clear_array(vecteur_t *x, index_t I){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		*x[i]=0.;
	}
	return;
}

//*************************************************************************************
void clear_table(table_t *x, index_t I, index_t J){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		clear_array(*x+i,J);
	}
	return;
}

//*************************************************************************************
void clear_cube(cube_t *x, index_t I, index_t J, index_t K){
//*************************************************************************************
	index_t k;
	for(k=0;k<K;k++){
		clear_table(*x+k,I,J);
	}
	return;
}

//*************************************************************************************
void clear_border_array(vecteur_t *x, index_t I){
//*************************************************************************************
	*x[0]=0;
	*x[I-1]=0;
	return;
}

//*************************************************************************************
void clear_border_table(table_t *x, index_t I, index_t J){
//*************************************************************************************
	index_t i;
	clear_array(*x,J);
	for(i=1;i<I-1;i++){
		clear_border_array(*x+i,J);
	}
	clear_array(*x+I-1,J);
	return;
}

//*************************************************************************************
void clear_border_cube(cube_t *x, index_t I, index_t J, index_t K){
//*************************************************************************************
	index_t k;
	clear_table(*x,I,J);
	for(k=1;k<K-1;k++){
		clear_border_table(*x+k,I,J);
	}
	clear_table(*x+K-1,I,J);
	return;
}

//*************************************************************************************
void b_clear_array(b_vecteur_t *x, index_t I){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		*x[i]=0;
	}
	return;
}

//*************************************************************************************
void b_clear_b_table(b_table_t *x, index_t I, index_t J){
//*************************************************************************************
	index_t i;
	for(i=0;i<I;i++){
		b_clear_array(*x+i,J);
	}
	return;
}

//*************************************************************************************
void b_clear_b_cube(b_cube_t *x, index_t I, index_t J, index_t K){
//*************************************************************************************
	index_t k;
	for(k=0;k<K;k++){
		b_clear_b_table(*x+k,I,J);
	}
	return;
}

//*************************************************************************************
void b_clear_border_array(b_vecteur_t *x, index_t I){
//*************************************************************************************
	*x[0]=0;
	*x[I-1]=0;
	return;
}

//*************************************************************************************
void b_clear_border_b_table(b_table_t *x, index_t I, index_t J){
//*************************************************************************************
	index_t i;
	b_clear_array(*x,J);
	for(i=1;i<I-1;i++){
		b_clear_border_array(*x+i,J);
	}
	b_clear_array(*x+I-1,J);
	return;
}

//*************************************************************************************
void b_clear_border_b_cube(b_cube_t *x, index_t K, index_t J, index_t I){
//*************************************************************************************
	index_t k;
	b_clear_b_table(*x,I,J);
	for(k=1;k<K-1;k++){
		b_clear_border_b_table(*x+k,I,J);
	}
	b_clear_b_table(*x+K-1,I,J);
	return;
}

//Fontions qui remettent a zero dans la memoire (00 AAA 00).

//*************************************************************************************
void clr_border(cube_t *x, index_t K, index_t I, index_t J, unsigned short int p){
//*************************************************************************************
	unsigned short int q;
	for(q=0;q<p;q++){
		dec_cube(K,I,x);
		clear_border_cube(x,I,J,K);
	}
	for(q=0;q<p;q++){
		inc_cube(K,I,x);
	}
	return;
}
