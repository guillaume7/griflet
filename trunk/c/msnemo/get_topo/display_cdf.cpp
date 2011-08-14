#include "stdafx.h"

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_nc_structs(s_nc_input_t* topo, s_nc_input_d* dims, s_nc_result* mask){
/***************************************************************************************/
	
	FILE* file;
	
	file = fopen("struct.txt","w");

	display_topo(file, topo);

	display_dims(file, dims);

	display_mask(file, mask);

	fclose(file);

	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_topo(FILE* file, s_nc_input_t* topo){
/***************************************************************************************/
	
	display_file_struct(stdout, &(topo->file));
	display_file_struct(file, &(topo->file));

	display_dim_struct(stdout, &(topo->x));
	display_dim_struct(file, &(topo->x));

	display_dim_struct(stdout, &(topo->y));
	display_dim_struct(file, &(topo->y));

	display_var_xy_struct(stdout, &(topo->r));
	display_var_xy_struct(file, &(topo->r));
	
	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_dims(FILE* file, s_nc_input_d* dims){
/***************************************************************************************/
	
	display_file_struct(stdout, &(dims->file));
	display_file_struct(file, &(dims->file));

	display_dim_struct(stdout, &(dims->date));
	display_dim_struct(file, &(dims->date));

	display_dim_struct(stdout, &(dims->x));
	display_dim_struct(file, &(dims->x));

	display_dim_struct(stdout, &(dims->y));
	display_dim_struct(file, &(dims->y));

	display_dim_struct(stdout, &(dims->y_edges));
	display_dim_struct(file, &(dims->y_edges));

	display_dim_struct(stdout, &(dims->z));
	display_dim_struct(file, &(dims->z));

	display_dim_struct(stdout, &(dims->z_edges));
	display_dim_struct(file, &(dims->z_edges));

	display_var_txyz_struct(stdout, &(dims->var));
	display_var_txyz_struct(file, &(dims->var));
	
	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_mask(FILE* file, s_nc_result* mask){
/***************************************************************************************/
	
	display_file_struct(stdout, &(mask->file));
	display_file_struct(file, &(mask->file));

	display_dim_struct(stdout, &(mask->x));
	display_dim_struct(file, &(mask->x));

	display_dim_struct(stdout, &(mask->y));
	display_dim_struct(file, &(mask->y));

	display_dim_struct(stdout, &(mask->y_edges));
	display_dim_struct(file, &(mask->y_edges));

	display_dim_struct(stdout, &(mask->z));
	display_dim_struct(file, &(mask->z));

	display_dim_struct(stdout, &(mask->z_edges));
	display_dim_struct(file, &(mask->z_edges));

	display_var_xyz_struct(stdout, &(mask->m));
	display_var_xyz_struct(file, &(mask->m));
	
	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_file_struct(FILE* file, s_nc_file* s_fil){
/***************************************************************************************/

	fprintf(file, "////////////////////////////////////////////////////////////////\n");
	fprintf(file, "----------------------------------------------------------------\n");
	fprintf(file, "file name: %s\n", s_fil->name_p);
	fprintf(file, "file id: %d \n", s_fil->ncid);
	fprintf(file, "number of dims: %d \n", s_fil->ndims);
	fprintf(file, "number of variables: %d \n", s_fil->nvars);
	fprintf(file, "id of unlimited dimension: %d \n", s_fil->unlimdimip);
	fprintf(file, "number of global attributes: %d \n", s_fil->ngatts);
	fprintf(file, "----------------------------------------------------------------\n\n");

	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_dim_struct(FILE* file, s_nc_dimension* s_dim){
/***************************************************************************************/

	fprintf(file, "----------------------------------------------------------------\n");
	fprintf(file, "dimension name: %s\n", s_dim->name_p);
	fprintf(file, "dimension id: %d\n", s_dim->id);
	fprintf(file, "variable id: %d\n", s_dim->varid);
	fprintf(file, "dimension length: %d\n", s_dim->length);
	fprintf(file, "number of attributes: %d\n", s_dim->natts);
	fprintf(file, "----------------------------------------------------------------\n\n");

	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_var_txyz_struct(FILE* file, s_nc_variable_txyz* s_var){
/***************************************************************************************/

	fprintf(file, "----------------------------------------------------------------\n");
	fprintf(file, "variable name: %s\n", s_var->name_p);
	fprintf(file, "variable id: %d\n", s_var->id);
	fprintf(file, "number of dimensions: %d\n", s_var->ndims);
	fprintf(file, "dimensions id shape: [%d %d %d %d]\n", s_var->dimshape_p[0], s_var->dimshape_p[1], s_var->dimshape_p[2], s_var->dimshape_p[3]);
	fprintf(file, "variable type: %d\n", s_var->type);
	fprintf(file, "number of attributes: %d\n", s_var->natts);
	fprintf(file, "----------------------------------------------------------------\n\n");

	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_var_xyz_struct(FILE* file, s_nc_variable_xyz* s_var){
/***************************************************************************************/

	fprintf(file, "----------------------------------------------------------------\n");
	fprintf(file, "variable name: %s\n", s_var->name_p);
	fprintf(file, "variable id: %d\n", s_var->id);
	fprintf(file, "number of dimensions: %d\n", s_var->ndims);
	fprintf(file, "dimensions id shape: [%d %d %d]\n", s_var->dimshape_p[0], s_var->dimshape_p[1], s_var->dimshape_p[2]);
	fprintf(file, "variable type: %d\n", s_var->type);
	fprintf(file, "number of attributes: %d\n", s_var->natts);
	fprintf(file, "----------------------------------------------------------------\n\n");

	return;
}

/***************************************************************************************/
//Displays the structure data to a file and on the screen.
void display_var_xy_struct(FILE* file, s_nc_variable_xy* s_var){
/***************************************************************************************/

	fprintf(file, "----------------------------------------------------------------\n");
	fprintf(file, "variable name: %s\n", s_var->name_p);
	fprintf(file, "variable id: %d\n", s_var->id);
	fprintf(file, "number of dimensions: %d\n", s_var->ndims);
	fprintf(file, "dimensions id shape: [%d %d]\n", s_var->dimshape_p[0], s_var->dimshape_p[1]);
	fprintf(file, "variable type: %d\n", s_var->type);
	fprintf(file, "number of attributes: %d\n", s_var->natts);
	fprintf(file, "----------------------------------------------------------------\n\n");

	return;
}