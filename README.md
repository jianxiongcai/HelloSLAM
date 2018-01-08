# HelloSLAM
# File Structure
- data (user input folder)
- frame_extractor: frame extraction from video
- line_extrator: line extraction from pgm files
- 3d_point_refinement: Do some refinement on the line extracted before and output the results in a 3D line cloud way.

# Usage
## Input data
Put the input data (IMU data and video) in folder 'data'.

## frame_extractor
Run extract.m (remember to modify the target mp4 name list)

## line_extrator
Require python3 installed and Ubuntu System
```
./setup.sh
./extract.py
``` 
Require MATLAB to run, this will create 'xxx-merge' folder and save results (.mat) in.
```
main.m
```