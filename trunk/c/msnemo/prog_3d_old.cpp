/*******Schema a deux dimensions pour l'advection, la diffusion et les termes source******/
#include "stdafx.h"

//*****************************************************************************************
void calcule(s_indexes *g, s_parameters *t, s_ncconcentration *c, s_blocs *b){
//*****************************************************************************************
	for(g->n=0; g->n<t->x.N; g->n++){	
		//writes the data every D times.
		if((g->n%t->x.D)==0){
			cdf_write(b->C_old, t, c, g->n/t->x.D); 
			printf(".");
		}
		switch(t->schema){
//-------------------Schema Upwind-------------------------------------------------------
		case SCH_UP:	
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_up(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_up_v(g,t,b)
								#endif
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//---------------------------------------------------------------------------------------
//------------schema hybride-------------------------------------------------------------
		case SCH_HY:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_hy(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_hy_v(g,t,b)
								#endif
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//--------------------------------------------------------------------------------
//--------Schema de diffusion-----------------------------------------------------
		case SCH_DI:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_di(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_di_v(g,t,b)
								#endif
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//--------------------------------------------------------------------------------
//----------Schema de source------------------------------------------------------
		case SCH_SO:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_so(g,t,b);
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//--------------------------------------------------------------------------------
//---------shcema hybride+diffusion-----------------------------------------------
		case SCH_HY | SCH_DI:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_hy(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_hy_v(g,t,b)
								#endif
								+c_di(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_di_v(g,t,b)
								#endif
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//--------------------------------------------------------------------------------
//----------schema upwind + diffusion---------------------------------------------
		case SCH_UP | SCH_DI:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_up(g,t,b)
								+c_di(g,t,b)
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			#ifdef BLOC_DIM_3D
			z_explicite(g,t,b);
			#endif
			break;
//--------------------------------------------------------------------------------
//----------Schema hybride+diffusion+source---------------------------------------
		case SCH_HY | SCH_DI | SCH_SO:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_hy(g,t,b)
								#ifdef BLOC_DIM_3D
								+	c_hy_v(g,t,b)
								#endif
								+c_di(g,t,b)
								#ifdef BLOC_DIM_3D
								+c_di_v(g,t,b)
								#endif
								+c_so(g,t,b) 
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//--------------------------------------------------------------------------------
//----------Schema upwind+diffusion+source----------------------------------------
		case SCH_UP | SCH_DI | SCH_SO:
			#ifdef BLOC_DIM_3D
			for(g->k=0; g->k<t->z.P; g->k++){
				g->kp=g->k-1;
				g->kn=g->k+1;
			#endif
				for(g->i=0; g->i<t->x.P; g->i++){
					g->ip=g->i-1;
					g->in=g->i+1;
					for(g->j=0; g->j<t->y.P; g->j++){
						g->jp=g->j-1;
						g->jn=g->j+1;
						C_NEW=C_OLD+c_up(g,t,b)
								+c_di(g,t,b)
								#ifdef BLOC_DIM_3D
								+z_explicite(g,t,b)
								#endif
								+c_so(g,t,b) 
								;
					}
				}
			#ifdef BLOC_DIM_3D
			}
			#endif
			break;
//-----------------------------------------------------------------------------------
		default:break;
		}
//--Ici on calcule à chaque pas de temps la fuite du traceur par les frontieres du domaine-- 
#ifdef LEAK_CALC_ON
		g->i=0;
		g->ip=g->i-1;
#ifdef BLOC_DIM_3D
		for(g->k=0;g->k<t->z.P;g->k++){
#endif
		for(g->j=0;g->j<t->y.P;g->j++){
			t->leak+=t->x.a*(fabs(U(ip))-U(ip))*C_OLD;
			t->leak+=t->x.b*C_FR_i(ip)*C_OLD;
		}
#ifdef BLOC_DIM_3D
		}
#endif
		g->i=t->x.P-1;
		g->in=t->x.P;
#ifdef BLOC_DIM_3D
		for(g->k=0;g->k<t->z.P;g->k++){
#endif
		for(g->j=0;g->j<t->y.P;g->j++){
			t->leak+=t->x.a*(U(i)+fabs(U(i)))*C_OLD;
			t->leak+=t->x.b*C_FR_i(in)*C_OLD;
		}
#ifdef BLOC_DIM_3D
		}
#endif
		g->j=0;
		g->jp=g->j-1;
#ifdef BLOC_DIM_3D
		for(g->k=0;g->k<t->z.P;g->k++){
#endif
		for(g->i=0;g->i<t->x.P;g->i++){
			t->leak+=t->y.a*(fabs(V(jp))-V(jp))*C_OLD;
			t->leak+=t->y.b*C_FR_j(jp)*C_OLD;
		}
#ifdef BLOC_DIM_3D
		}
#endif
		g->j=t->y.P-1;
		g->jn=t->y.P;
#ifdef BLOC_DIM_3D
		for(g->k=0;g->k<t->z.P;g->k++){
#endif
		for(g->i=0;g->i<t->x.P;g->i++){
			t->leak+=t->y.a*(V(j)+fabs(V(j)))*C_OLD;
			t->leak+=t->y.b*C_FR_j(jn)*C_OLD;
		}
#ifdef BLOC_DIM_3D
		}
#endif
#ifdef BLOC_DIM_3D
		g->k=0;
		g->kp=g->k-1;
		for(g->i=0;g->i<t->x.P;g->i++){
		for(g->j=0;g->j<t->y.P;g->j++){
			t->leak+=t->z.a*(fabs(W(kp))-W(kp))*C_OLD;
			t->leak+=t->z.b*C_FR_k(kp)*C_OLD;
		}
		}
#endif
#ifdef BLOC_DIM_3D
		g->k=t->z.P-1;
		g->kn=t->z.P;
		for(g->i=0;g->i<t->x.P;g->i++){
		for(g->j=0;g->j<t->y.P;g->j++){
			t->leak+=t->z.a*(fabs(W(k))-W(k))*C_OLD;
			t->leak+=t->z.b*C_FR_k(k)*C_OLD;
		}
		}
#endif
#endif
//------------------------------------------------------------------------------------------
		b->C_temp = b->C_old;
		b->C_old  = b->C_new;
		b->C_new  = b->C_temp;
	}
	return;
}

/* ATTENTION CE SCHEMA EST PEUT-ETRE PLUS SUR MAIS IL EST BEAUCOUP PLUS LENT!!!
//ATTENTION: IL FAUT TENIR EN COMPTE LE FACTEUR 0.5 QUI MANQUE DANS x->a!!!!!
#ifdef UCONSTSWITCH_OFF
//*****************************************************************************************
//Schema numerique du terme d'advection upwind horizontal.
double c_up(s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	return	t->x.a*( (U(ip)+fabs(U(ip)))*C_i(ip) +( U(ip)-fabs(U(ip))
					-  U(i) -fabs(U(i)) )*C_i(i)  - (U(i) -fabs(U(i)))*C_i(in) )
		+	t->y.a*( (V(jp)+fabs(V(jp)))*C_j(jp) +( V(jp)-fabs(V(jp))
					-  V(j) -fabs(V(j)) )*C_j(j)  - (V(j) -fabs(V(j)))*C_j(jn) );
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//routine numeriques upwind verticale (3D).
double c_up_v(s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	return t->z.a*( (W(kp)+fabs(W(kp)))*C_k(kp) +( W(kp)-fabs(W(kp))
					  -  W(k) -fabs(W(k)) )*C_k(k)  - (W(k) -fabs(W(k))) *C_k(kn) );
}
#endif
#endif
*/
#ifdef UCONSTSWITCH_OFF
//*****************************************************************************************
//Schema numerique du terme d'advection upwind horizontal.
double c_up(s_indexes *g, s_parameters *t, s_blocs *b){
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

//Attention! Celui-ci etait un schema 10% plus lent mais beaucoup plus elegant a ecrire.
/*	double a, result1, result2;
	a=U(ip);
	if(a>0.0)	result1=a*C_i(ip);
	else 		result1=a*C_i(i);
	a=U(i);
	if(a>0.0)	result1-=a*C_i(i);
	else		result1-=a*C_i(in);
	a=V(jp);
	if(a>0.0)	result2=a*C_j(jp);
	else		result2=a*C_j(j);
	a=V(j);
	if(a>0.0)	result2-=a*C_j(j);
	else		result2-=a*C_j(jn);
	return t->x.a*result1+t->y.a*result2;*/
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//routine numeriques upwind verticale (3D).
double c_up_v(s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	if(W(kp)>0.0){
		if(W(k)>0.0){
			return t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k));
		}
		else{
			return t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn));
		}
	}
	else{
		if(W(k)>0.0){
			return t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k));
		}
		else{
			return t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn));
		}
	}
/*	double a,result;
	a=W(kp);
	if(a>0.0)	result=a*C_k(kp);
	else 		result=a*C_k(k);
	a=W(k);
	if(a>0.0)	result-=a*C_k(k);
	else		result-=a*C_k(kn);
	return result*t->z.a;*/
}
#endif
#endif

#ifdef UCONSTSWITCH_ON
//*****************************************************************************************
double c_up(s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	return	t->x.a*( (t->x.u+fabs(t->x.u))*C_i(ip) +( t->x.u-fabs(t->x.u)
					-  t->x.u -fabs(t->x.u))*C_i(i)  - (t->x.u -fabs(t->x.u))*C_i(in) )
		+	t->x.a*( (t->y.u+fabs(t->y.u))*C_j(jp) +( t->y.u-fabs(t->y.u)
					-  t->y.u -fabs(t->y.u) )*C_j(j)  - (t->y.u -fabs(t->y.u))*C_j(jn) );
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//routine numeriques upwind verticale (3D).
double c_up_v(s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	return t->z.a*( (t->z.u+fabs(t->z.u))*C_k(kp) +( t->z.u-fabs(t->z.u)
					  -  t->z.u -fabs(t->z.u) )*C_k(k)  - (t->z.u -fabs(t->z.u)) *C_k(kn) );
}
#endif
#endif


//*****************************************************************************************
//Schema numerique hybride horizontal.
double c_hy( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	double bet[2];
	double result;
	bt_i(g, b, bet); //Calcule les coefs beta pour i.
	result = t->x.a*( bet[0]*((U(ip)+fabs(U(ip)))*C_i(ip) + (U(ip)-fabs(U(ip)))*C_i(i))
					+ (1.-bet[0])*U(ip)*(C_i(ip)+C_i(i))
					- bet[1]*((U(i)+fabs(U(i)))*C_i(i) + (U(i)-fabs(U(i)))*C_i(in))
					- (1.-bet[1])*U(i)*(C_i(i)+C_i(in)) );
	bt_j(g, b, bet); //Calcule les coefs beta pour j.
	result+= t->y.a*( bet[0]*((V(jp)+fabs(V(jp)))*C_j(jp) + (V(jp)-fabs(V(jp)))*C_j(j))
					+ (1.-bet[0])*V(jp)*(C_j(jp)+C_j(j))
					- bet[1]*((V(j)+fabs(V(j)))*C_j(j) + (V(j)-fabs(V(j)))*C_j(jn))
					- (1.-bet[1])*V(j)*(C_j(j)+C_j(jn)) );
	if(C_OLD+result>0)return result;
   else return -C_OLD;
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//Schema numerique hybride vertical.
double c_hy_v( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	double bet[2];
	bt_k(g, b, bet); //Calcule les coefs beta pour i.
	return t->z.a*(bet[0]*((W(kp)+fabs(W(kp)))*C_k(kp) + (W(kp)-fabs(W(kp)))*C_k(k))
					+ (1.-bet[0])*W(kp)*(C_k(kp)+C_k(k))
					- bet[1]*((W(k)+fabs(W(k)))*C_k(k) + (W(k)-fabs(W(k)))*C_k(kn))
					- (1.-bet[1])*W(k)*(C_k(k)+C_k(kn)));
}
#endif

//*****************************************************************************************
//En x calcule le coefficient de decentrement beta du schema hybride de I.D.James.
void bt_i(s_indexes *g, s_blocs *b, double *bet){
//*****************************************************************************************
	double bet_p, bet_c, bet_n;
	double x,y;
	x=fabs(C_i(ip)-C_i(ip-1));
	y=fabs(C_i(i)-C_i(ip));
	if((bet_p=y+x)>EPS) bet_p=(y-x)/bet_p;
	else bet_p=0;
	x=y;
	y=fabs(C_i(in)-C_i(i));
	if((bet_c=y+x)>EPS) bet_c=(y-x)/bet_c;
	else bet_c=0;
	x=y;
	y=fabs(C_i(in+1)-C_i(in));
	if((bet_n=y+x)>EPS) bet_n=(y-x)/bet_n;
	else bet_n=0;
	if(bet_p>bet_c)bet[0] = bet_p;
	else 				bet[0] = bet_c;
	if(bet_c>bet_n)bet[1] = bet_c;
	else				bet[1] = bet_n;
	return;
}

//*****************************************************************************************
//En y calcule le coefficient de decentrement beta du schema hybride de I.D.James.
void bt_j(s_indexes *g, s_blocs *b, double *bet){
//*****************************************************************************************
	double bet_p, bet_c, bet_n;
	double x,y;
	x=fabs(C_j(jp)-C_j(jp-1));
	y=fabs(C_j(j)-C_j(jp));
	if((bet_p=y+x)>EPS) bet_p=(y-x)/bet_p;
	else bet_p=0;
	x=y;
	y=fabs(C_j(jn)-C_j(j));
	if((bet_c=y+x)>EPS) bet_c=(y-x)/bet_c;
	else bet_c=0;
	x=y;
	y=fabs(C_j(jn+1)-C_j(jn));
	if((bet_n=y+x)>EPS) bet_n=(y-x)/bet_n;
	else bet_n=0;
	if(bet_p>bet_c)bet[0] = bet_p;
	else 				bet[0] = bet_c;
	if(bet_c>bet_n)bet[1] = bet_c;
	else				bet[1] = bet_n;
	return;
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//En z calcule le coefficient de decentrement beta du schema hybride de I.D.James.
void bt_k(s_indexes *g, s_blocs *b, double *bet){
//*****************************************************************************************
	double bet_p, bet_c, bet_n;
	double x,y;
	x=fabs(C_k(kp)-C_k(kp-1));
	y=fabs(C_k(k)-C_k(kp));
	if((bet_p=y+x)>EPS) bet_p=(y-x)/bet_p;
	else bet_p=0;
	x=y;
	y=fabs(C_k(kn)-C_k(k));
	if((bet_c=y+x)>EPS) bet_c=(y-x)/bet_c;
	else bet_c=0;
	x=y;
	y=fabs(C_k(kn+1)-C_k(kn));
	if((bet_n=y+x)>EPS) bet_n=(y-x)/bet_n;
	else bet_n=0;
	if(bet_p>bet_c)bet[0] = bet_p;
	else bet[0] = bet_c;
	if(bet_c>bet_n)bet[1] = bet_c;
	else bet[1] = bet_n;
	return;
}
#endif

//*****************************************************************************************
//Schema numerique du terme de diffusion horizontal.
double c_di( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	if(C_FR_i(ip)==TRUE){
		if(C_FR_i(in)==TRUE){
			if(C_FR_j(jp)==TRUE){
				if(C_FR_j(jn)==TRUE){
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-2*C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if(C_FR_j(jn)==TRUE){
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
			if(C_FR_j(jp)==TRUE){
				if(C_FR_j(jn)==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if(C_FR_j(jn)==TRUE){
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
		if(C_FR_i(in)==TRUE){
			if(C_FR_j(jp)==TRUE){
				if(C_FR_j(jn)==TRUE){
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)-C_OLD+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if(C_FR_j(jn)==TRUE){
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
			if(C_FR_j(jp)==TRUE){
				if(C_FR_j(jn)==TRUE){
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)-2*C_OLD+C_j(jn));
				}
				else{
					return 	t->x.b*(C_i(ip)+C_i(in))
						+	t->y.b*(C_j(jp)-C_OLD+C_j(jn));
				}
			}
			else{
				if(C_FR_j(jn)==TRUE){
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
/*	return 	t->x.b*(C_i(ip)-(C_FR_i(ip)+C_FR_i(in))*C_OLD+C_i(in))
		+	t->y.b*(C_j(jp)-(C_FR_j(jp)+C_FR_j(jn))*C_OLD+C_j(jn));*/
}

//*****************************************************************************************
#ifdef BLOC_DIM_3D
//Schema numerique du terme de diffusion vertical.
double c_di_v( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	if(C_FR_k(kp)==TRUE){
		if(C_FR_k(kn)==TRUE){
			return 	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
		}
		else{
			return 	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
		}
	}
	else{
		if(C_FR_k(kn)==TRUE){
			return 	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
		}
		else{
			return 	t->z.b*(C_k(kp)+C_k(kn));
		}
	}
//	return 	t->z.b*(C_k(kp)-(C_FR_k(kp)+C_FR_k(kn))*C_OLD+C_k(kn));
}
#endif

//*****************************************************************************************
//Schema numerique du terme source.
double c_so( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	return t->x.tt*C_SO;
}

//*****************************************************************************************
//Calcule la masse a la fin de l'experience
double mass_calculation(s_parameters *t, s_blocs *b){
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

#ifdef BLOC_DIM_3D
//*****************************************************************************************
//Schema numerique explicite des termes verticaux.
double z_explicite( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	if(C_FR_k(kp)==TRUE){
		if(C_FR_k(kn)==TRUE){
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
			}
		}
		else{
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
		}
	}
	else{
		if(C_FR_k(kn)==TRUE){
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
		}
		else{
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
			}
		}
	}
}
#endif

#ifdef BLOC_DIM_3D
//*****************************************************************************************
//Schema numerique explicite des termes verticaux.
void z_implicite( s_indexes *g, s_parameters *t, s_blocs *b){
//*****************************************************************************************
	if(C_FR_k(kp)==TRUE){
		if(C_FR_k(kn)==TRUE){
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-2*C_OLD+C_k(kn));
				}
			}
		}
		else{
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
		}
	}
	else{
		if(C_FR_k(kn)==TRUE){
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)-1*C_OLD+C_k(kn));
				}
			}
		}
		else{
			if(W(kp)>0.0){
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(kp)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
			}
			else{
				if(W(k)>0.0){
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(k))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
				else{
					return	t->z.a*(W(kp)*C_k(k)-W(k)*C_k(kn))
						+	t->z.b*(C_k(kp)+C_k(kn));
				}
			}
		}
	}
}
#endif
