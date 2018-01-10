# line_extractor
## Description
This part of codes can
- extarct line segaments using LSD
- merge lines
Note: this folder contains two part: LSD and line-merging. DO NOT forget to run the line merging section

## Usage
### LSD line extraction
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

### Lines merging (also in line_extractor folder)
Require MATLAB to run, this will create 'lines' folder and save results (.mat) in.
```
src/main.m
```

## Expected Results  
### LSD results
LSD extraction results is stored to both txt and esp files. You can open the esp files directly to visualize lines.
### Line merging results
Run ```visualize.m``` to visualize those lines.

## References
1. Ikehata, Satoshi, et al. "[Panoramic Structure from Motion via Geometric Relationship Detection.](http://arxiv.org/abs/1612.01256 )" arXiv preprint arXiv:1612.01256 (2016).
2. Grompone von Gioi, R., Jakubowicz, J., Morel, J.-M., & Randall, G. (2012). LSD: a Line Segment Detector. Image Processing On Line, 2, 35–55. https://doi.org/10.5201/ipol.2012.gjmr-lsd
3. Tavares, J. (1995). A new approach for merging edge line segments. RecPad95, (January). Retrieved from http://repositorio-aberto.up.pt/handle/10216/420