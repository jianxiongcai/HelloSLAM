# HelloSLAM
## Description
This project aims to create 3D panorama with line tracking approach. The main pipeline is following. 

## File Structure
- **presentation**: A folder containing all material used in the presentation. Besides, a MATLAB figure used for demo result is also in this folder.
- **data** (user input folder)
- **frame_extractor**: frame extraction from video
- **essentail_extractor**: extract essential and transformation from frames
- **imuXvideo**: an APP to capture the IMU data and videos
- **line_extrator**: line extraction from pgm files
- **3d\_point_refinement**: Do some refinement on the line extracted before and output the results in a 3D line cloud way.
- **manhattan_extractor**: extract manhattan frames and manhattan lines from data
- TODO

## Usage
### Input data
Put the input data (IMU data and video) in folder 'data'.

### Detail usage:
Other usage please refer to detailed README in each sub-folder (sub-program) following this order. (You may skip some steps if you downloaded pre-processed data)  

- **frame_extractor**
- **essential_extractor**
- **imuXvideo**
- **line_extrator**
- **line_tracking**
- **manhattan_extractor**
- TODO


### frame_extractor
Run extract.m (remember to modify the target mp4 name list).

### essential_extractor
Require MATLAB to run.  
Run ```src\main.m``` to extract the essential matrices and the camera transformation matrices between 2 extracted frames. Run ```visualization.m``` to see the trajectory result.

### imuXvideo
Open ```FYP.xcodeproj``` using Xcode.  
Connect you iOS device and choose the device at the selector near "Run" button.  
Run it on the device.

### line_extrator
Require python3 installed and Ubuntu System (macOS System is also supported).
```
$ ./setup.sh 
$ ./extract.py
``` 
In macOS, run
```
$ ./setup.sh. 
$ python3 extract.py
``` 

Require MATLAB to run, this will create 'xxx-merge' folder and save results (.mat) in.
```
main.m
```

### manhattan_extractor
Download the dataset and unzip it into the ```../data/``` folder.
Require MATLAB to run.  
Run ```../frame_extractor/src/extract.m``` to extract the frames first (the ```interval``` parameter in it should be set to 3), and run the ```../line_extrator``` contents follow the instuctions.   
Run ```main.m```, the path of the data need to be modified. After running ```main.m```, run ```visualize.m``` see the results.  
Download the corresponding datasets here:  
[Dataset 1](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(Laundry Room),  
[Dataset 2](http://oxygvbxux.bkt.clouddn.com/dataset2.zip)(Vending Machine),  
[Dataset 3](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(SIST Corridor).


## Reference
Ikehata, S., Boyadzhiev, I., Shan, Q., & Furukawa, Y. (2016). Panoramic Structure from Motion via Geometric Relationship Detection. Retrieved from http://arxiv.org/abs/1612.01256
Tavares, J. (1995). A new approach for merging edge line segments. RecPad95, (January). Retrieved from http://repositorio-aberto.up.pt/handle/10216/420
Grompone von Gioi, R., Jakubowicz, J., Morel, J.-M., & Randall, G. (2012). LSD: a Line Segment Detector. Image Processing On Line, 2, 35–55. https://doi.org/10.5201/ipol.2012.gjmr-lsd
Coughlan, J. M. (1999). Manhattan World : Compass Direction from a Single Image by Bayesian Inference 2 Previous Work and Three- Dimen- sional Geometry. Camera, 0(c).
VisualSFM : A Visual Structure from Motion System. Available at http://ccwu.me/vsfm/

## Acknowledgment 
- This project is the repository for CS284 SLAM Course Project, under supervision of Prof.laurent kneip , ShanghaiTech University.
- Line Extraction part is using LSD, the opensource library. Available at http://www.ipol.im/pub/art/2012/gjmr-lsd/
- Some related works results used in presentation is using MATLAB SfM example and VisualSFM to produce.

## Contact
- CAI JIANXIONG, caijx@shanghaitech.edu.cn

- ZENG XIANGCHEN, zengxch@shanghaitech.edu.cn

- GAO LING, gaoling1@shanghaitech.edu.cn
