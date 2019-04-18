yetton_rem_detector MATLAB Python Package

1. Prerequisites for Deployment 

Verify that version 9.3 (R2017b) of the MATLAB Runtime is installed.   

If the MATLAB Runtime is not installed, you can run the MATLAB Runtime installer.
To find its location, enter
  
    >>mcrinstaller
      
at the MATLAB prompt.

Alternatively, download and install the Windows version of the MATLAB Runtime for R2017b 
from the following link on the MathWorks website:

    http://www.mathworks.com/products/compiler/mcr/index.html
   
For more information about the MATLAB Runtime and the MATLAB Runtime installer, see 
Package and Distribute in the MATLAB Compiler SDK documentation  
in the MathWorks Documentation Center.    

NOTE: You will need administrator rights to run the MATLAB Runtime installer. 


Verify that a Windows version of Python 2.7, 3.4, 3.5, and/or 3.6 is installed.

2. Installing the yetton_rem_detector Package

A. Change to the directory that contains the file setup.py and the subdirectory 
yetton_rem_detector. If you do not have write permissions, copy all its contents to a 
temporary location and change to that directory.

B. Execute the command:

    python setup.py install [options]
    
If you have full administrator privileges, and install to the default location, you do 
not need to specify any options. Otherwise, use --user to install to your home folder, or 
--prefix="installdir" to install to "installdir". In the latter case, add "installdir" to 
the PYTHONPATH environment variable. For details, refer to:

    https://docs.python.org/2/install/index.html


3. Using the yetton_rem_detector Package

The yetton_rem_detector package is on your Python path. To import it into a Python script 
or session, execute:

    import yetton_rem_detector

If a namespace must be specified for the package, modify the import statement accordingly.
