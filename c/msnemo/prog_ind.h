#ifndef PROG_IND_H
#define PROG_IND_H

typedef unsigned int index_t;

//Structure des indexes.
typedef struct indexes{
	index_t i,j,n;
	index_t ip,jp; //previous
   index_t in,jn; //next
}s_indexes;

#endif
