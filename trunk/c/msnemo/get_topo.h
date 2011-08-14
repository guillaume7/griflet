#ifndef WRITE_TOPO_H
#define WRITE_TOPO_H

//By comparing the topo source's data, writes the topo in the target.
void write_topo(s_nc_input_t*, s_nc_result*);

//Defines the window of the target dimensions.
void set_target_index_window(s_nc_result*, size_t*);

//Gets the depth.
double get_depth(s_nc_result*, size_t);

//Gets the size of the inner area.
size_t get_area(size_t*);

//Defines the coordinates window.
void set_target_edge_coord(s_nc_result*, size_t*, double*);

//Defines the window indexes of the source.
void set_source_index_window(s_nc_input_t*, size_t*, double*);

#endif
