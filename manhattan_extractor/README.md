# manhattan_extractor
## Description
This part of codes can extract the manhattan frame and manhatten lines from the image sequence. IMU data is needed.

## Usage
Download the dataset and unzip it into the ```../data/``` folder.
Require MATLAB to run.  
Run ```../frame_extractor/src/extract.m``` to extract the frames first (the ```interval``` parameter in it should be set to 3), and run the ```../line_extrator``` contents follow the instuctions.   
Run ```main.m```, the path of the data need to be modified. After running ```main.m```, run ```visualize.m``` see the results.  
Download the corresponding datasets here:  
[Dataset 1](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(Laundry Room),  
[Dataset 2](http://oxygvbxux.bkt.clouddn.com/dataset2.zip)(Vending Machine),  
[Dataset 3](http://oxygvbxux.bkt.clouddn.com/dataset1.zip)(SIST Corridor).

## Expected Results  
![](https://raw.githubusercontent.com/ernestcai/HelloSLAM/epipolar-dev/presentation/pics/manhattan1.jpg)  
![](https://raw.githubusercontent.com/ernestcai/HelloSLAM/epipolar-dev/presentation/pics/manhattan2.jpg)  
![](https://raw.githubusercontent.com/ernestcai/HelloSLAM/epipolar-dev/presentation/pics/manhattan3.jpg)

## References
1. Ikehata, Satoshi, et al. "[Panoramic Structure from Motion via Geometric Relationship Detection.](http://arxiv.org/abs/1612.01256 )" arXiv preprint arXiv:1612.01256 (2016).
2. Kroeger, Till, Dengxin Dai, and Luc Van Gool. "[Joint vanishing point extraction and tracking.](https://www.cv-foundation.org/openaccess/content_cvpr_2015/papers/Kroeger_Joint_Vanishing_Point_2015_CVPR_paper.pdf)" Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2015.