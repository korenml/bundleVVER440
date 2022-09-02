# bundleVVER440
bundleVVER440 is a gmsh script to create a computational grid of simplified VVER-440 fuel assembly.
The script generates computational grid for whole assembly including coolant, cladding and fuel.

Two variants are currently available
<ul>
* Multiregion mesh  
* Singleregion mesh  
<li>
where each variant is evoked by region variable
```
region = 0; # multiregion
region = 1; # coolant region
region = 2; # cladding region
region = 3; # fuel region
```
## OpenFOAM usage
To convert mesh into the OpenFOAM use:

```{r}
gmshToFoam VVER440bundle.msh
```
or
```
gmshToFoam -region <region_name> VVER440bundle.msh
```
where `<region_name>` can be coolant, cladding or fuel. The mesh will be created in separate region folder

## Requirements
Tested on  *gmsh-4.8.5* and *gmsh-4.10.5* versions

## Current status

The script is still under development. There are several know bugs which have to be solved in order to fully automatize. There is a problem with thickness of boundary layer where for larger boundary layer the mesh generation fails with
```
Segmentation fault (core dumped)
```
error.



