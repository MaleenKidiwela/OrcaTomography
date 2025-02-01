## README file for Orca Volcano Tomography Models and Bathymetry

This dataset contains 3 tomography models developed for Orca Volcano, Bransfield Basin, Antarctica
1) Pg_Orca_velocity.nc - Isotropic Pg tomography model
2) Pg_Anis_Orca_velocity.nc - Anisotropic Pg tomography model
3) Pg_Pmc_Orca_velocity.nc - Isotropic Pg-Pmc tomography model
4) Orca_bathymetry.nc - Bathymetry file for Orca Volcano

   
As part of the Bransfield Volcano Seismology (BRAVOSEIS) project (Almendros et al., 2020), a tomographic experiment was conducted on Orca Volcano and the ridges extending to the west and southwest (Figure 2) using 15 ocean bottom seismometers (OBSs), each equipped with a three-component seismometer and hydrophone. Fifteen instruments were US short-period Ocean Bottom Seismograph Instrument Pool (OBSIP) seismometers, and 1 was a German Instrument Pool for Amphibian Seismology (DEPAS) broadband OBS. The network had an instrument spacing of 3-4 km around the volcano with 3 OBS in the caldera area ~1.5 km apart. For the tomography experiment, a total of 2426 air gun shots were fired with a 6-gun 2540- cubic-inch (41.6 L) array. Shots were spaced 200 m apart along shot lines totaling 485 km in length. Most shots were on twenty one 21-km-long lines (T1-29) oriented southwest-northeast and spaced 0.5 to 1 km apart with the highest shot density above the caldera and the southwest ridge (Figure 2b). To generate deeper ray paths from the northeast, tomography shots were also obtained along two curved lines (T31-36) running southeast-northwest. This active source tomography experiment imaged the three-dimensional isotropic and anisotropic P-wave (Pg) velocity structure of the upper- crust of Orca Volcano. Additionally, we developed a method to incorporate secondary arrivals to improve the imaging of the volcano’s magma chamber that produced the Pg- Pmc isotropic model. Each value in the 3D velocity model represents a 0.2 km x 0.2 km x 0.2 km cube.
README for Pg_Orca_velocity.nc
This README describes the structure and contents of the Pg_Orca_velocity.nc file The file contains a 3D velocity model—converted from the MATLAB structure (`srModel`)—along with corresponding spatial coordinates.
Each value in the 3D model represents a 0.2 km x 0.2 km x 0.2 km cube


---
Contents
1. 1D Coordinate Variables - xg
- Dimensions: `x_dim` (size = 136) - Data Type: `double`
- Description: X coordinate (grid)
- yg
- Dimensions: `y_dim` (size = 101) - Data Type: `double`
- Description: Y coordinate (grid)
- zg
- Dimensions: `z_dim` (size = 51) - Data Type: `double`
- Description: Z coordinate (grid)
2. 2D Geographic Variables - LAT
- Dimensions: 136, 101
- Data Type: `double`
- Description: Latitude (degrees north)
- LON
- Dimensions: 136, 101
- Data Type: `double`
- Description: Longitude (degrees east)
3. 3D Velocity Variable - Velocity
- Dimensions: 136, 101, 515
- Data Type: `double`
- Description: 3D velocity model in km/s (reciprocal of slowness)

---
Global Attributes
- title: Pg 3D velocity Model for Orca
- description: Converted from srModel struct
---
Example Usage
**MATLAB**:
matlab

Read variables from the NetCDF file
info = ncinfo('Pg_Orca_velocity.nc');
xg = ncread('Pg_Orca_velocity.nc', 'xg');
yg = ncread('Pg_Orca_velocity.nc', 'yg');
zg = ncread('Pg_Orca_velocity.nc', 'zg');
lat = ncread('Pg_Orca_velocity.nc', 'LAT');
lon = ncread('Pg_Orca_velocity.nc', 'LON'); vel = ncread('Pg_Orca_velocity.nc', 'Velocity');
______________________________________________________________________
## README for Pg_Anis_Orca_velocity.nc

This README describes the structure and contents of the Pg_Orca_velocity.nc file The file contains a 3D velocity model—converted from the MATLAB structure (`srModel`)—along with corresponding spatial coordinates.
Each value in the 3D model represents a 0.2 km x 0.2 km x 0.2 km cube

Contents
1. 1D Coordinate Variables - xg
- Dimensions: `x_dim` (size = 136) - Data Type: `double`
- Description: X coordinate (grid)
- yg
- Dimensions: `y_dim` (size = 101) - Data Type: `double`

- Description: Y coordinate (grid)
- zg
- Dimensions: `z_dim` (size = 51) - Data Type: `double`
- Description: Z coordinate (grid)
2. 2D Geographic Variables - LAT
- Dimensions: 136, 101
- Data Type: `double`
- Description: Latitude (degrees north)
- LON
- Dimensions: 136, 101
- Data Type: `double`
- Description: Longitude (degrees east)
3. 3D Velocity Variable - Velocity
- Dimensions: 136, 101, 51
- Data Type: `double`
- Description: 3D velocity model in km/s (reciprocal of slowness)
---
Global Attributes
- title: `Pg 3D velocity Model for Orca`
- description: `Converted from srModel struct`
---
Example Usage
MATLAB:
% Read variables from the NetCDF file
info = ncinfo('Pg_Anis_Orca_velocity.nc');
xg = ncread('Pg_Anis_Orca_velocity.nc', 'xg');
yg = ncread('Pg_Anis_Orca_velocity.nc', 'yg');
zg = ncread('Pg_Anis_Orca_velocity.nc', 'zg');
lat = ncread('Pg_Anis_Orca_velocity.nc', 'LAT');
lon = ncread('Pg_Anis_Orca_velocity.nc', 'LON'); vel = ncread('Pg_Anis_Orca_velocity.nc', 'Velocity');

______________________________________________________________________
## README for Pg_Pmc_Orca_velocity.nc

This README describes the structure and contents of the Pg_Pmc_Orca_velocity.nc file.
The file contains a 3D velocity model—converted from the MATLAB structure (`srModel`)—along with corresponding spatial coordinates.
Each value in the 3D model represents a 0.2 km x 0.2 km x 0.2 km cube ---
Contents

1. 1D Coordinate Variables - xg
- Dimensions: `x_dim` (size = 136) - Data Type: `double`
- Description: X coordinate (grid)
- yg
- Dimensions: `y_dim` (size = 101) - Data Type: `double`
- Description: Y coordinate (grid)
- zg
- Dimensions: `z_dim` (size = 51) - Data Type: `double`
- Description: Z coordinate (grid)
2. 2D Geographic Variables - LAT
- Dimensions: 136, 101
- Data Type: `double`
- Description: Latitude (degrees north)
- LON
- Dimensions: 136, 101
- Data Type: `double`
- Description: Longitude (degrees east)
3. 3D Velocity Variable

- Velocity
- Dimensions: 136, 101, 51
- Data Type: `double`
- Description: 3D velocity model in km/s (reciprocal of slowness)
---
Global Attributes
- title: `Pg-Pmc 3D velocity Model for Orca`
- description: `Converted from srModel struct`
---
Example Usage
MATLAB:
% Read variables from the NetCDF file
info = ncinfo('Pg_Pmc_Orca_velocity.nc');
xg = ncread('Pg_Pmc_Orca_velocity.nc', 'xg');
yg = ncread('Pg_Pmc_Orca_velocity.nc', 'yg');
zg = ncread('Pg_Pmc_Orca_velocity.nc', 'zg');
lat = ncread('Pg_Pmc_Orca_velocity.nc', 'LAT');
lon = ncread('Pg_Pmc_Orca_velocity.nc', 'LON'); vel = ncread('Pg_Pmc_Orca_velocity.nc', 'Velocity');
______________________________________________________________________
## README for Orca_bathymetry.nc

This README describes the **Orca_bathymetry.nc** file, which stores bathymetry and related geographic information originating from the `srElevation` structure in MATLAB. The data in this file includes elevation (or depth) values, latitude, longitude, and additional coordinate grids.

Contents
1. Dimensions
- lat: The number of latitude points (2474).
- lon: The number of longitude points (5547).
2. Variables 1. latitude

- Data Type: `double`
- Dimensions: 2474
- Description: Array of latitude values (1D).
2. Longitude
- Data Type: `double`
- Dimensions: 5547
- Description: Array of longitude values (1D).
3. data
- Data Type: `double`
- Dimensions: 2474, 5547
- Description: 2D array of bathymetry data (e.g., elevation or depth).
4. LON
- Data Type: `double`
- Dimensions: 2474, 5547
- Description: 2D grid of longitude values (meshgrid-style).
5. LAT
- Data Type: `double`
- Dimensions: 2474, 5547
- Description: 2D grid of latitude values (meshgrid-style).
6. X
- Data Type: `double`
- Dimensions: 2474, 5547
- Description: 2D grid for the X coordinate, possibly in projected units (if provided).
7. Y
- Data Type: `double`
- Dimensions: 2474, 5547
- Description: 2D grid for the Y coordinate, possibly in projected units (if provided).
Usage Examples
Below are examples of how to read the data in MATLAB

MATLAB:
Obtain NetCDF file information
info = ncinfo('Orca_bathymetry.nc');
% Read the variables
lat = ncread('Orca_bathymetry.nc', 'latitude');
lon = ncread('Orca_bathymetry.nc', 'longitude');
data = ncread('Orca_bathymetry.nc', 'data'); % 2D bathymetry
LON_2D = ncread('Orca_bathymetry.nc', 'LON'); % 2D longitude grid
LAT_2D = ncread('Orca_bathymetry.nc', 'LAT'); % 2D latitude grid
X_2D = ncread('Orca_bathymetry.nc', 'X'); % 2D X coordinate (if applicable) Y_2D = ncread('Orca_bathymetry.nc', 'Y'); % 2D Y coordinate (if applicable)
