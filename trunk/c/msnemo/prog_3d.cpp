/*******Schema a deux dimensions pour l'advection, la diffusion et les termes source******/
#include "stdafx.h"

//*****************************************************************************************
void calcule(s_indexes *g, s_all_parameters *t, s_nc_result *c, s_memory_blocs *b){
//*****************************************************************************************

	if(t->user.instant == ON){

		for(g->n=0; g->n<t->x.N; g->n++){	
			//writes the data every D times.
			if((g->n%t->x.D)==0){
				cdf_write(b->C_old, t, c, g->n/t->x.D); 
				printf(".");
			}
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
				for(g->j=0; g->j<t->y.P; g->j++){
					g->jp=g->j-1;
					g->jn=g->j+1;
							C_NEW	= C_OLD
									+ c_up(g,t,b)
									+ c_di(g,t,b);
				}
				}
			b->C_temp = b->C_old;
			b->C_old  = b->C_new;
			b->C_new  = b->C_temp;
		}
	
	}
	else{

		for(g->n=0; g->n<t->x.N; g->n++){	
			//writes the data every D times.
			if((g->n%t->x.D)==0){
				cdf_write(b->C_old, t, c, g->n/t->x.D); 
				printf(".");
			}
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
				for(g->j=0; g->j<t->y.P; g->j++){
					g->jp=g->j-1;
					g->jn=g->j+1;
							C_NEW	= C_OLD
									+ c_up(g,t,b)
									+ c_di(g,t,b)
									+ c_so(g,t,b);
				}
				}
			b->C_temp = b->C_old;
			b->C_old  = b->C_new;
			b->C_new  = b->C_temp;
		}

	}

	return;
}

//*****************************************************************************************
//Schema numerique du terme source.
double c_so( s_indexes *g, s_all_parameters *t, s_memory_blocs *b){
//*****************************************************************************************
	return t->x.tt*C_SO;
}

//*****************************************************************************************
//Calcule la masse a la fin de l'experience
double mass_calculation(s_all_parameters *t, s_memory_blocs *b){
//*****************************************************************************************
	double mass;
	s_indexes ind;
	s_indexes *g;
	g=&ind;
	mass=0.0;
#ifdef BLOC_DIM_3D
	for(g->k=0;g->k<t->z.P;g->k++){
#endif
	for(g->i=0;g->i<t->x.P;g->i++){
		for(g->j=0;g->j<t->y.P;g->j++){
			mass+=C_OLD;
		}
	}
#ifdef BLOC_DIM_3D
	}
#endif
	return mass;
}
/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/

//*****************************************************************************************
//Schema numerique du terme d'advection upwind horizontal.
double c_up(s_indexes *g, s_all_parameters *t, s_memory_blocs *b){
//*****************************************************************************************
	if(U(ip)>0.0){
		if(U(i)>0.0){
			if(V(jp)>0.0){
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(jn));	
				}
			}
			else{
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(jn));
				}
			}
		}
		else{
			if(V(jp)>0.0){
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(jn));	
				}
			}
			else{
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(ip)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(jn));	
				}
			}
		}
	}
	else{
		if(U(i)>0.0){
			if(V(jp)>0.0){
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(j));	
				}
				else{
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(jn));	
				}
			}
			else{
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(i))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(jn));	
				}
			}
		}
		else{
			if(V(jp)>0.0){
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(j));	
				}
				else{
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(jp)-V(j)*C_j(jn));	
				}
			}
			else{
				if(V(j)>0.0){
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(j));
				}
				else{
					return	t->x.a*(U(ip)*C_i(i)-U(i)*C_i(in))
						+	t->y.a*(V(jp)*C_j(j)-V(j)*C_j(jn));	
				}
			}
		}
	}
}

//*****************************************************************************************
//Schema numerique du terme de diffusion horizontal.
double c_di( s_indexes *g, s_all_parameters *t, s_memory_blocs *b){
//*****************************************************************************************
	if( b->C_fr[g->ip][g->j] ==TRUE){
		if( b->C_fr[g->in][g->j] ==TRUE){
			if( b->C_fr[g->i][g->jp] ==TRUE){
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)+C_j(jn));
				}
			}
		}
		else{
			if( b->C_fr[g->i][g->jp] ==TRUE){
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)+C_j(jn));
				}
			}
		}
	}
	else{
		if( b->C_fr[g->in][g->j] ==TRUE){
			if( b->C_fr[g->i][g->jp] ==TRUE){
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)+C_j(jn));
				}
			}
		}
		else{
			if( b->C_fr[g->i][g->jp] ==TRUE){
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if( b->C_fr[g->i][g->jn] ==TRUE){
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)+C_j(jn));
				}
			}
		}
	}
}
