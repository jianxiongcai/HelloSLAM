# HelloSLAM
# File Structure
- data (user input folder)
- frame_extractor: frame extraction from vedio
- line_extrator: line extraction from pgm files

# Usage
## Input data
Put the input data (IMU data and vedio) in folder 'data'.

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