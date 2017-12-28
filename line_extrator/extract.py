#! /usr/bin/python3
import os;
folder_path = "../data";
folders = os.listdir(folder_path);
print(folders)
for folder in folders:
	if (os.path.isdir(folder)):
		for image in os.listdir("../data"):
			image_path = folder_path+"/"+folder+"/"+image;
			saving_path = folder_path+"/"+folder+"/"+image;
			print(image_path);
			exit(0);