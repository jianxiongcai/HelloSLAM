#! /usr/bin/python3

def remove_ext(p):
	print(p);
	res = "";
	for k in range(len(p)):
		if (p[len(p)-k-1]=="."):
			break;

	for i in range(len(p)-k-1):
		res += p[i];
	return res;



import os;
data_path = "../data";
folders = os.listdir(data_path);
for folder in folders:

	folder_path = data_path + "/" + folder;
	print("Checking folder: "+ folder_path)

	if (os.path.isdir(folder_path)):
		for image in os.listdir(folder_path):
			image_path = folder_path+"/"+image;
			saving_path = remove_ext(folder_path+"/"+image);
			cmd = "./lsd " + " -P " + saving_path +".esp " + image_path + " " +saving_path + ".txt";
			print(cmd);
			os.system(cmd);
			