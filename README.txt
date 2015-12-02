::Automatic REM detector::
v0.1
This repository contains the matlab code for the Automatic REM Detector (For LOC and ROC) developed by Yetton et al:
doi: 

It is important to read sections XX and XX before using these algorithms. 
Please use the github page for all feature sugesstions, comments and bug reporting. This is pre-release code and to be used at your own risk. Its a good idea to validate this software on your own data before using it blindly. See the validation section below

::Contents::
-Master code to run all algorithms
-Code to generate REM statistics
Algorithms:
-Yetton Et Al's Machine Learning algorithm (```
YettonEtAl_MachineLearning
```)
-Yetton Et Al's Best Single Feature (```YettonEtAl_SingleFeature```)
-Yetton Et Al's Threshold algorithm (```YettonEtAl_Threshhold```)
The following methods from previous liturature were implmented.
-Minard Et Al (```MinardEtAl```)
-Agarwal Et Al (```AgarwalEtAl```)
-Hatzilabrou Et Al (```HatzilabrouEtAl```)
-Smith Et Al (```SmithEtAl```)
-Doman Et Al (```DomanEtAl```)

::User Guide::
:Running the Detector:
1. Download this file through git or use the download as zip button ->
2. Open matlab and navigate to the unziped remDetector folder
3. Change settings such as sample rate if you need to at the top of importAndParseData.m (default 256Hz)
4. To run all detector (except the McPartland detector) enter 'runDetector' in the command line
	i) if you would like to run each detector individually, then enter a cell array of detecotor names (see detector names above) e.g. to run Yetton et al's Machine Learning and Thresholding algorithms:
```runDetector({'YettonEtAl_MachineLearning','YettonEtAl_Thresholding'})```
5. A diolog will appear, please selected your EEG files (in .edf) format, they will then be converted to .mat files for futher processing. Note that if a .mat file of the same name as the .edf file exists in the chosen directory, then that .mat file will be used instead and no conversion will take place.
6. A second diolog will apear and ask for a .csv file containig the time (in samples) of the start and end of REM sleep (See REM start and end file below for format). If no file is selected, all the record will be assumed to be REM sleep.
7. Sit back and relax, and the detector starts detecting REM's. See the output file below for information on the format of data returned returned   

:REM start and end file:
Usually the edf file will contain other stage data. This detector was not developed to handle other stages, and will not work on on epochs containing NREM sleep. You may defined the 'periods' of REM sleep in each EDF file by adding the start and end (in samples) of each REM detector period. There may be multiple periods in a single .edf record. These will be output seperatly. 
See the example rem start and end file (remStartAndEndExample.csv) for how to format the .csv file

:Output Data:
Output (in the same file as the EDF's) will be a simple .csv file containing each detectors messurement of REM density aswell as a .mat file
The .mat file has remDensity messurements, lables (NoREM, 1REM, 2REM for each 1 second window) and REM locations in samples (when applicable)

:Training the detector:
If the you believe your REM are significantly different from the REMs in Yetton Et Al then retraining of algorithms is desirable. It is advised to have at least as much data as Yetton Et Al used for training. See Yetton et al for details.
Based on how popular this algorithm is, we will provide details of how to retrain the algorithm. Please email bdyetton(AT)gmail(DOT)com for more information.

:Validation:
Some of the algorithms here may produce better or worse results on your dataset. Your definition of a REM may be different from Yetton Et Al's, or your PSG channel placement may be slightly different. You can test the validity of this algorithm by marking REM's in your data and then comparing to detected REM's OR by calculating various discriptive statistics of REM and comparing to those in Yetton Et Al.
Code to compare can be found in calREMValidity.m (which gives reliability statistics) and calREMStats.m (which plots distributions of REM statistics for comparison to Yetton Et Al).



