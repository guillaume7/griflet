#ifndef PROG_MAI_H
#define PROG_MAI_H

#define THIS_VERSION "v0.20"

//Ceci est le nombre d'arguments dans la ligne de commandes.
#define ARGN 5

//Ceux-ci donnent l'ordre des arguments de la ligne de commandes.
#define ARG_U 1
#define ARG_V 2
#define ARG_W 3
#define ARG_TOPO 4
#define ARG_OUT 5
#define ARG_USER 6

//Fonction qui demande a l'utilisateur quel schema employer.

#ifdef BLOC_DIM_2D

#define B_I blocs_p->i.p[index.i][index.j]
#define B_J blocs_p->j.p[index.i][index.j]

#endif

#ifdef BLOC_DIM_3D

#define B_I(s) blocs_p->i.s[index.k][index.i][index.j]
#define B_J(s) blocs_p->j.s[index.k][index.i][index.j]
#define B_K(s) blocs_p->k.s[index.k][index.i][index.j]

#endif

#endif

