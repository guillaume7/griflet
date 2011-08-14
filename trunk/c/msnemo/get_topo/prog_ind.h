#ifndef PROG_IND_H
#define PROG_IND_H

typedef unsigned int index_t;

//Structure des indexes.
typedef struct indexes{
	index_t i,j,k,n;
	index_t ip,jp,kp; //previous
   index_t in,jn,kn; //next
}s_indexes;

#endif
