#include "stdafx.h"

/***********************************************************************************************/
//This is the write routine
void write_topo(s_nc_input_t* topo, s_nc_result* mask){
/***********************************************************************************************/

	int status;
	size_t *i, *j, *k;
	size_t *m, *n;

	//read variable
	double floor; 
	size_t sizeofarea;
	size_t landarea;
	size_t waterarea;
	size_t source_index[2]; // n, m.
	size_t source_index_window[4]; //[0],[1] m; [2],[3] n.
	m = &source_index[S_LON]; //lon
	n = &source_index[S_LAT]; //lat

	//write variable
	byte_t msk; 
	size_t target_index[3]; // k, j, i.
	size_t target_index_window[6]; //[0],[1] k; [2],[3] j; [4],[5] i.
	double target_edge_coord[4]; //[0],[1] lon; [2],[3] lat.
	double depth;
	i = &target_index[T_LON]; //lon
	j = &target_index[T_LAT]; //lat
	k = &target_index[T_DEP]; //depth

	//Defines the window indexes of the target.
	set_target_index_window(mask, target_index_window);

	printf("Building ");
	
	/////////////////////////////////////////////////////////////////////////
#ifdef TEST_1_DEPTH_OFF
	for( (*k) = target_index_window[0]; (*k) < target_index_window[1]; (*k)++){
#else
	(*k)=0;
#endif

	//Gets the depth.
	depth = get_depth(mask, target_index[T_DEP]);

	for( (*j) = target_index_window[2]; (*j) < target_index_window[3]; (*j)++){
	for( (*i) = target_index_window[4]; (*i) < target_index_window[5]; (*i)++){
	/////////////////////////////////////////////////////////////////////////

		//Defines the coordinates window.
		set_target_edge_coord(mask, target_index, target_edge_coord);

		//Defines the window indexes of the source.
		set_source_index_window(topo, source_index_window, target_edge_coord);

		//Initializes the area of land and water.
		landarea = 0;
		waterarea= 0;

		//Gets the size of the inner area.
		sizeofarea = get_area(source_index_window);

		//read value ...
		if(source_index_window[0] < source_index_window[1]){/***************************/
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			for( (*n) = source_index_window[2]; (*n) < source_index_window[3]; (*n)++){ 
			for( (*m) = source_index_window[0]; (*m) < source_index_window[1]; (*m)++){
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
				status = nc_get_var1_double(topo->file.ncid, topo->r.id, source_index, &floor);
				CDF_ERROR
				if( floor > depth ) landarea++;
				else waterarea++;
			//___________________________________________________________________________
			////////////////////////////////////////////////////////////////////////////
			}
			}
			////////////////////////////////////////////////////////////////////////////
			//--------------------------------------------------------------------------
		}/******************************************************************************/
		else{/**************************************************************************/
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			for( (*n) = source_index_window[2]; (*n) < source_index_window[3]; (*n)++){ 
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			for( (*m) = source_index_window[0]; (*m) < topo->x.length; (*m)++){
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
				status = nc_get_var1_double(topo->file.ncid, topo->r.id, source_index, &floor);
				CDF_ERROR
				if( floor > depth ) landarea++;
				else waterarea++;
			//___________________________________________________________________________
			////////////////////////////////////////////////////////////////////////////
			}
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			for( (*m) = 0; (*m) < source_index_window[1]; (*m)++){
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
				status = nc_get_var1_double(topo->file.ncid, topo->r.id, source_index, &floor);
				CDF_ERROR
				if( floor > depth ) landarea++;
				else waterarea++;
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			}
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
			//___________________________________________________________________________
			/////////////////////////////////////////////////////////////////////////////
			}
			/////////////////////////////////////////////////////////////////////////////
			//---------------------------------------------------------------------------
		}/******************************************************************************/
	
		//perform treatment to value
		if( landarea > waterarea ) msk = LAND;
		else msk = WATER;
	
		//write mask value
		status = nc_put_var1_short(mask->file.ncid, mask->m.id, target_index, &msk);
		CDF_ERROR
	
	/////////////////////////////////////////////////////////////////////////
	}
	}
	printf(".");
#ifdef TEST_1_DEPTH_OFF
	}
#endif
	/////////////////////////////////////////////////////////////////////////

	printf(" Done!\n");
	return;
}

/***********************************************************************************************/
//Defines the window of the target dimensions.
void set_target_index_window(s_nc_result* m_p, size_t* i_p){
/***********************************************************************************************/

	//k
	i_p[0] = 0;
	i_p[1] = m_p->z.length;  

	//j - lat
	i_p[2] = 0;
	i_p[3] = m_p->y.length;

	//i - lon
	i_p[4] = 0;
	i_p[5] = m_p->x.length-1;

	return;
}

/***********************************************************************************************/
//Defines the coordinates window.
void set_target_edge_coord(s_nc_result* m_p, size_t* i_p, double* edge_coord){
/***********************************************************************************************/
	int status;
	size_t index;

	//Gets the left edge of the longitude
	index = i_p[T_LON];
	status = nc_get_var1_double(m_p->file.ncid, m_p->x.varid, &index, &edge_coord[0]);
	CDF_ERROR
	edge_coord[0] = edge_coord[0] - 0.5;
	if( edge_coord[0] > 360.0 ) edge_coord[0] = edge_coord[0] - 360.0;

	//Gets the right edge of the longitude
	index = i_p[T_LON] + 1;
	status = nc_get_var1_double(m_p->file.ncid, m_p->x.varid, &index, &edge_coord[1]);
	CDF_ERROR
	edge_coord[1] = edge_coord[1] - 0.5;
	if( edge_coord[1] > 360.0 ) edge_coord[1] = edge_coord[1] - 360.0;

	//Gets the left edge of the latitude
	index = i_p[T_LAT];
	status = nc_get_var1_double(m_p->file.ncid, m_p->y_edges.varid, &index, &edge_coord[2]);
	CDF_ERROR
	
	//Gets the right edge of the latitude
	index = i_p[T_LAT] + 1;
	status = nc_get_var1_double(m_p->file.ncid, m_p->y_edges.varid, &index, &edge_coord[3]);
	CDF_ERROR

	return;
}

/***********************************************************************************************/
//Defines the window indexes of the source.
void set_source_index_window(s_nc_input_t* t_p, size_t* i_p, double* v_p){
/***********************************************************************************************/
	int status;
	double tmp;
	size_t i;

	//Define the lower edge of the lon coordinate.
	tmp = v_p[0] - 1.;
	for(i=0; tmp < v_p[0];i++){
		status = nc_get_var1_double(t_p->file.ncid, t_p->x.varid, &i, &tmp);
		CDF_ERROR
	}
	i_p[0] = i;

	//Define the upper edge of the lon coordinate.
	tmp = v_p[1] - 1.;
	for(i=0; tmp < v_p[1];i++){
		status = nc_get_var1_double(t_p->file.ncid, t_p->x.varid, &i, &tmp);
		CDF_ERROR
	}
	i_p[1] = i;

	//Define the lower edge of the lat coordinate.
	tmp = v_p[2] - 1.;
	for(i=0; tmp < v_p[2];i++){
		status = nc_get_var1_double(t_p->file.ncid, t_p->y.varid, &i, &tmp);
		CDF_ERROR
	}
	i_p[2] = i;

	//Define the upper edge of the lat coordinate.
	tmp = v_p[3] - 1.;
	for(i=0; tmp < v_p[3];i++){
		status = nc_get_var1_double(t_p->file.ncid, t_p->y.varid, &i, &tmp);
		CDF_ERROR
	}
	i_p[3] = i;

	return;
}

/***********************************************************************************************/
//Gets the depth.
double get_depth(s_nc_result* m_p, size_t i){
/***********************************************************************************************/
	int status;
	double depth;

	status = nc_get_var1_double(m_p->file.ncid, m_p->z.varid, &i, &depth);
	CDF_ERROR

	return -depth;
}

/***********************************************************************************************/
//Gets the size of the inner area.
size_t get_area(size_t* window_index_p){
/***********************************************************************************************/

	return (window_index_p[3] - window_index_p[2]) * (window_index_p[1] - window_index_p[0]);

}
