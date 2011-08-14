/**************fonction allocation en memoire************/
#ifndef PROG_ALL_H
#define PROG_ALL_H

#ifdef ONLY_FLOATS
#define double float
#define NC_GET_VAR1 nc_get_var1_float
#endif

#ifndef ONLY_FLOATS
#define NC_GET_VAR1 nc_get_var1_double
#endif

/*Au choix entre double * et double far * */
typedef double * vecteur_t;
typedef double ** table_t;
typedef double *** cube_t;

/*Definit nos variables pour le traceur:
1D ->vecteur_t
2D ->table_t
3D ->cube_t */

/*Definit nos matrices de source et de frontieres*/
typedef bool_t * b_vecteur_t;
typedef bool_t ** b_table_t;
typedef bool_t *** b_cube_t;

/*****************************************************************/

vecteur_t array_alloc( index_t, unsigned short int);
table_t table_alloc( index_t, index_t, unsigned short int);
cube_t cube_alloc(index_t, index_t, index_t, unsigned short int);
void table_free(table_t, index_t, unsigned short int);
void cube_free(cube_t, index_t, index_t, unsigned short int);
void dec_array(vecteur_t*);
void inc_array(vecteur_t*);
void dec_table(index_t, table_t*);
void inc_table(index_t, table_t*);
void dec_cube(index_t, index_t, cube_t*);
void inc_cube(index_t, index_t, cube_t*);
void fill_array(vecteur_t*, index_t, double);
void fill_table(table_t*, index_t, index_t, double);
void fill_cube(cube_t*, index_t, index_t, index_t, double);
void clear_array(vecteur_t*, index_t);
void clear_table(table_t*, index_t, index_t);
void clear_cube(cube_t*, index_t, index_t, index_t);
void clear_border_array(vecteur_t*, index_t);
void clear_border_table(table_t*, index_t, index_t);
void clear_border_cube(cube_t*, index_t, index_t, index_t);

/*****************************************************************/

b_vecteur_t b_array_alloc( index_t, unsigned short int);
b_table_t b_table_alloc( index_t, index_t, unsigned short int);
b_cube_t b_cube_alloc(index_t, index_t, index_t, unsigned short int);
void b_table_free(b_table_t, index_t, unsigned short int);
void b_cube_free(b_cube_t, index_t, index_t, unsigned short int);
void b_dec_array(b_vecteur_t*);
void b_inc_array(b_vecteur_t*);
void b_dec_table(index_t, b_table_t*);
void b_inc_table(index_t, b_table_t*);
void b_dec_cube(index_t, index_t, b_cube_t*);
void b_inc_cube(index_t, index_t, b_cube_t*);
void b_clear_array(b_vecteur_t*, index_t);
void b_clear_table(b_table_t*, index_t, index_t);
void b_clear_cube(b_cube_t*, index_t, index_t, index_t);
void b_clear_border_array(b_vecteur_t*, index_t);
void b_clear_border_table(b_table_t*, index_t, index_t);
void b_clear_border_cube(b_cube_t*, index_t, index_t, index_t);

/*****************************************************************/

void clr_border(cube_t*, index_t, index_t, index_t);

#endif
