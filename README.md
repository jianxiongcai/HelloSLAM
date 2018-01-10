# HelloSLAM
## Description
This project aims to create 3D panorama with line tracking approach. The main pipeline is in the presentation pdf.

## File Structure
- **presentation**: A folder containing all material used in the presentation. Besides, a MATLAB figure used for demo result is also in this folder.
- **data** (user input folder)
- **frame_extractor**: frame extraction from video
- **line_extractor**: line extraction from pgm files
- **essential_extractor**: extract essential and transformation from frames
- **imuXvideo** (forked and modified from [jasonhu5](https://github.com/jasonhu5)): an APP to capture the IMU data and videos
- **line_tracking**: line tracking using the results from line_extractor
- **3d\_point_refinement**: Do some refinement on the line extracted before and output the results in a 3D line cloud way.
- **manhattan_extractor**: extract Manhattan frames and Manhattan lines from data

## Dataset
Download the corresponding datasets here:  
[Dataset 1](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(Laundry Room),  
[Dataset 2](http://oxygvbxux.bkt.clouddn.com/dataset2.zip)(Vending Machine),  
[Dataset 3](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(SIST Corridor).


## Usage
### Input data
Put the input data (IMU data and video) in folder 'data'.

### Detail usage:
Other usage please refer to detailed README in each sub-folder (sub-program) following this order. (You may skip some steps if you downloaded pre-processed data)  

- **frame_extractor**
- **line_extractor**
- **essential_extractor**
- **imuXvideo**
- **line_tracking**
- **manhattan_extractor**
- **3d\_point_refinement**


### frame_extractor
For extracting frame from MP4 file, run *extract.m*
For extracting frame from MOV file, run *extract_mov.m*
This will create 'rgb' folder to store the resulting pgm (actually images are gray value images...)

### line_extractor
##### LSD line extraction
Require python3 installed and Ubuntu System (macOS System is also supported). This will read in 'data/rgb' and store results into 'lines-raw'
```
$ ./setup.sh 
$ ./extract.py
``` 
In macOS, run
```
$ ./setup.sh. 
$ python3 extract.py
``` 

##### Lines merging (also in line_extractor folder)
Require MATLAB to run, this will create 'lines' folder and save results (.mat) in.
```
src/main.m
```


### essential_extractor
Require MATLAB to run.  
Run ```src\main.m``` to extract the essential matrices and the camera transformation matrices between 2 extracted frames. Run ```visualization.m``` to see the trajectory result.

### imuXvideo
Open ```FYP.xcodeproj``` using Xcode.  
Connect you iOS device and choose the device at the selector near "Run" button.  
Run it on the device.

### Line Tracking
Require MATLAB to run. 
run ```main.m```

### manhattan_extractor
Download the dataset and unzip it into the ```../data/``` folder.
Require MATLAB to run.  
Run ```../frame_extractor/src/extract.m``` to extract the frames first (the ```interval``` parameter in it should be set to 3), and run the ```../line_extrator``` contents follow the instuctions.   
Run ```main.m```, the path of the data need to be modified. After running ```main.m```, run ```visualize.m``` see the results.  

### 3d\_point_refinement
Refer to detailed README.md in the folder.

## Reference
- Ikehata, S., Boyadzhiev, I., Shan, Q., & Furukawa, Y. (2016). Panoramic Structure from Motion via Geometric Relationship Detection. Retrieved from http://arxiv.org/abs/1612.01256
- Tavares, J. (1995). A new approach for merging edge line segments. RecPad95, (January). Retrieved from http://repositorio-aberto.up.pt/handle/10216/420
- Grompone von Gioi, R., Jakubowicz, J., Morel, J.-M., & Randall, G. (2012). LSD: a Line Segment Detector. Image Processing On Line, 2, 35–55. https://doi.org/10.5201/ipol.2012.gjmr-lsd
- Coughlan, J. M. (1999). Manhattan World : Compass Direction from a Single Image by Bayesian Inference 2 Previous Work and Three- Dimen- sional Geometry. Camera, 0(c).
- VisualSFM : A Visual Structure from Motion System. Available at http://ccwu.me/vsfm/

## Acknowledgment 
- This project is the repository for CS284 SLAM Course Project, under supervision of Prof.laurent kneip , ShanghaiTech University.
- Line Extraction part is using LSD, the opensource library. Available at http://www.ipol.im/pub/art/2012/gjmr-lsd/
- Some related works results used in presentation is using MATLAB SfM example and VisualSFM to produce.
- The imuXvideo APP is forked and modified from [jasonhu5](https://github.com/jasonhu5)'s project.

## Contact
- CAI JIANXIONG, caijx@shanghaitech.edu.cn

- ZENG XIANGCHEN, zengxch@shanghaitech.edu.cn

- GAO LING, gaoling@shanghaitech.edu.cn
