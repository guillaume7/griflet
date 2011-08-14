/*Schema a deux dimensions pour l'advection, la diffusion et les termes source*/
#ifndef PROG_3D_H
#define PROG_3D_H

//-----Ici on definit les entrees du vecteur de ints sch[]----------
#define UP  0
#define HY  1
#define DI  2
#define SO  3
//------------------------------------------------------------------

#ifdef BLOC_DIM_2D

#define C_NEW b->C_new[g->i][g->j]
#define C_OLD b->C_old[g->i][g->j]
#define C_i(q) b->C_old[g->q][g->j]
#define C_j(q) b->C_old[g->i][g->q]
#define C_SO  b->C_so[g->i][g->j]
#define C_FR  b->C_fr[g->i][g->j]
#define C_FR_i(q) b->C_fr[g->q][g->j]
#define C_FR_j(q) b->C_fr[g->i][g->q]
#define U(q) b->V_u[g->q][g->j]
#define V(q) b->V_v[g->i][g->q]
#define P(s) b->s.p[g->i][g->j]
#define C(s) b->s.c[g->i][g->j]
#define N(s) b->s.n[g->i][g->j]

#endif

#ifdef BLOC_DIM_3D

#define C_NEW b->C_new[g->k][g->i][g->j]
#define C_NEW_k(q) b->C_new[g->q][g->i][g->j]
#define C_OLD b->C_old[g->k][g->i][g->j]
#define C_i(q) b->C_old[g->k][g->q][g->j]
#define C_j(q) b->C_old[g->k][g->i][g->q]
#define C_k(q) b->C_old[g->q][g->i][g->j]
#define C_SO  b->C_so[g->k][g->i][g->j]
#define C_FR  b->C_fr[g->k][g->i][g->j]
#define C_FR_i(q) b->C_fr[g->k][g->q][g->j]
#define C_FR_j(q) b->C_fr[g->k][g->i][g->q]
#define C_FR_k(q) b->C_fr[g->q][g->i][g->j]
#define U(q) b->V_u[g->k][g->q][g->j]
#define V(q) b->V_v[g->k][g->i][g->q]
#define W(q) b->V_w[g->q][g->i][g->j]
#define P(s) b->s.p[g->k][g->i][g->j]
#define C(s) b->s.c[g->k][g->i][g->j]
#define N(s) b->s.n[g->k][g->i][g->j]
#define G(s) b->k.g[g->s]

#endif

#define A(m) b->m.a[g->m]
#define B(m) b->m.b[g->m]

/*******************************************/

//Fonctions qui calculent le coeff de decentrement entre un 
//schema d'advection upwind et FCTS.
void bt_i(s_indexes*, s_memory_blocs*, double*);
void bt_j(s_indexes*, s_memory_blocs*, double*);

//routines numeriques horizontales (2D).
double c_hy(s_indexes*, s_all_parameters*, s_memory_blocs*);
double c_so(s_indexes*, s_all_parameters*, s_memory_blocs*);

#ifdef BLOC_DIM_3D

//routines numeriques verticales (3D).
void bt_k(s_indexes*, s_memory_blocs*, double*);
double c_hy_v(s_indexes*, s_all_parameters*, s_memory_blocs*);
void z_implicite(s_indexes*, s_all_parameters*, s_memory_blocs*);

#endif

//routine principale.
void calcule( s_indexes*, s_all_parameters*, s_nc_result*, s_memory_blocs*);

//routine qui calcule la masse totale.
double mass_calculation(s_all_parameters*, s_memory_blocs*);

//routines adhoc
double c_so( s_indexes*, s_all_parameters*, s_memory_blocs*);
double c_di( s_indexes*, s_all_parameters*, s_memory_blocs*);
double c_up(s_indexes*, s_all_parameters*, s_memory_blocs*);

#endif

