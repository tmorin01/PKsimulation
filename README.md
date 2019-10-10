# PKsimulation
**A MATLAB Simulation Tool for Pharmacokinetic PET Experiments - Updated 2/1/16**
>Author: **Tom Morin** (contact at thomas[dot]morin[at]tufts[dot]edu)

>Mentor: **Hsiao-Ying (Monica) Wey, PhD**

>Hooker Research Group

>Martinos Center for Biomedical Imaging

>Massachusetts General Hospital

## Overview
Positron Emission Tomography (PET) Neuroimaging is time consuming and expensive.  Mathematical models and computer simulations can help scientists make more informed decisions about new experimental paradigms in PET, reducing costs and minimizing scan times.  However, many chemists, biologists, and neuroscientists who work with PET lack the training in Computer Science necessary to carry out such simulations.  The PK Simulation Tool was designed in Matlab with an easy-to-use GUI so that any scientist can perform their own pharmacokinetic PET simulations without ever typing a single line of code.  The tool comes with a collection of commonly used compartmental models, radiotracers, and infusion paradigms already built in.  For more advanced users, all features are completely customizable.

## System Requirements
1. Mac OSX or more recent *(coming soon to Windows)*
  - _**Note:** Will probably work on Linux machines, but has not been sufficiently tested._
2. MATLAB_R2015a or more recent

## Installation
1. Download the code as a zip folder and unzip it in a new directory.  
  - _**Note:** Be sure that the unzipped folder is named_ `PKsimulation`
2. Open MATLAB and add the `PKsimulation-master` folder and subfolders to the current path.
3. Navigate into the `PKsimulation-master` folder.
3. Type `pk_sim_gui` into the MATLAB command line and hit enter.  The GUI window should appear.

## File Structure
- **AIF\_txts**
  - A collection of .txt files for custom infusion paradigms.  These .txt files follow a specific format.
- **Default\_TACs**
  - A collection of .txt files that contain actual non-human primate time activity curves for Carfentanil and LY279 radiotracers.  These specific tracers are used in our lab and we were interested in testing simulated data against this actual data.
- **display\_boxes\_menus**
  - These scripts are used to adjust the kinetic parameters and the appearance/disappearance of menus based on user selections.
- **FDG\_Plasma\_Files**
  - Old data files that will be excluded from subsequent versions of PK Simulation
- **graveyard**
  - Because this program is a work in progress, this directory contains old scripts that are no longer used.  These files will be excluded from subsequent versions of PK Simulation.
- **gui**
  - Contains the .fig and corresponding .m files for all GUIs associated with the program.  (All GUIs were created with MATLAB's GUIDE tool.)
- **Logan\_Reference**
  - Scripts for the implementation of the Logan Reference Model
- **One\_TC\_Model**
  - Scripts for the implementation of a One-Tissue Compartment Model
- **original\_codes**
  - Original scripts from Hsiao-Ying (Monica) Wey, PhD. for the Two-Tissue Compartment Model, off of which the PK Simulation Tool is based.  These scripts show the old method for completing PK Simulations, which required commenting and uncommenting different blocks of code in order to run the desired simulation.  These files will be excluded from subsequent versions of PK Simulation.
- **Pictures**
  - Selected graphs, figures, and screenshots from old versions of the tool that have been used in presentations.  This directory will be excluded in subsequent versions of PK Simulation
- **Radiotracers**
  - A collection of .txt files that specify the kinetic parameters for each built-in radiotracer.  This directory will be excluded in subsequent versions of PK Simulation
- **SRTM**
  - scripts for the implementation of the Simplified Reference Tissue Model. This method is based off [Joe Mandeville's implementation of his JIP tool](http://www.nmr.mgh.harvard.edu/~jbm/jip/jip-srtm/).
- **tests**
  - Various test scripts used during the design of this tool.  This directory will be excluded from subsequent versions of PK Simulation.
- **Two\_TC\_Model**
  - Scripts for the implementation of a Two-Tissue Compartment Model.
- **utilities**
  - Various scripts for methods that are repeatedly used (i.e. derivative/integral of a vector, writing data to a .txt file, etc.)
- **Other Files**
  - pk\_sim.m --- launches the PK Simulation Tool
  - pk\_sim\_main.m --- links together the main GUI (pk\_sim\_gui.m), the various model implementations (e.g. SRTM\_sim.m), and plotting the final graphs (plot\_results.m).
  - get\_tracer\_struct.m --- converts information in the Radiotracer .txt files into a struct
  - Other files to be added to this README soon...

## For More Information...
...check out the `PK Simulation User Guide` (a PDF file located in the `PKsimulation` directory)

