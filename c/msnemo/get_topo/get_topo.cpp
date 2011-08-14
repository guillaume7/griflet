#include "stdafx.h"

/***********************************************************************************************/
//This is the main routine!
int main(int argc, char* argv[])
/***********************************************************************************************/
{
	//Tests the pointers:
	size_t i;
	int p[5];
	int *index_p;
	p[0]=0;
	p[1]=1;
	p[2]=2;
	p[3]=3;
	p[4]=4;
	i = 0;
	printf("[%d %d %d %d %d]\n", p[0], p[1], p[2], p[3], p[4]);
	index_p = &(p[3]);
	printf("[%d %d %d %d %d]\n", i-3, i-2, i-1, i, i+1);
	printf("[%d %d %d %d %d]\n", index_p[i-3], index_p[i-2], index_p[i-1], index_p[i], index_p[i+1]);

	//Builds the source topo meta-structure
	nc_input_t topo;
	build_input_t(&topo);

	//Builds the source dims meta-structure
	nc_input_d dims;
	build_input_d(&dims);

	//Builds the target mask meta-structure
	s_nc_result mask;
	build_result(&mask);

	//creates the nc_file structure of the topo source
	//opens the topo source nc_file, ready for reading...
	set_topo(&topo);

	//creates the nc_file structure of the dims source
	//opens the dims source nc_file, ready for reading...
	set_dims(&dims);

	//creates the cdf_file structure of the target
	//creates the target cdf_file; ready for writing...
	set_mask(&mask, &dims);

	//Copies the dims (and respective vars) from the dims source to the target.
	copy_data(&dims, &mask);
	
	//Displays the structure data to a file and on the screen.
	display_nc_structs(&topo, &dims, &mask);

	//By comparing the topographical data, writes the landmask in the target.
	write_topo(&topo, &mask);

	//close the files.
	close(&mask, &dims, &topo);

	return 0;
}