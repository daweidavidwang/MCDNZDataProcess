#header MCDnoising
#author David Wang
import os
import os.path
def compare(filelist1,filelist2):
	result = [];
	for i in filelist1:
		if i not in filelist2:
			result.append(i);
	return result;

def fixlist(filelist,a):
	result = [];
	for i in filelist:
		result.append(i[:-a]);
	return result;

if __name__ == "__main__":
	spp8 = 1;
	spp16 = 1;
	spp32 = 1;
	spp64 = 1;
	
	gtdir = "E:\\datasetcombine\\valuableGT"
	dir8 = "F:\\dataset1_var_train\\4spp"
	dir16 = "F:\\dataset1_var_train\\8spp"
	dir32 = "F:\\dataset1_var_train\\16spp"
	dir64 = "F:\\dataset1_var_train\\32spp"

	filelistgt = [];
	filelist8 = [];
	filelist16 = [];
	filelist32 = [];
	filelist64 = [];
	filelisttmp = [];
	filelistgt = os.listdir(gtdir);
	filelistgt = fixlist(filelistgt,4);
	if dir8:
		filelisttmp = fixlist(filelisttmp,12);
		filelist8 = compare(filelistgt,filelisttmp);
		print("8spp",filelist8);
	if dir16:
		filelisttmp = os.listdir(dir16);
		filelisttmp = fixlist(filelisttmp,12);
		filelist16 = compare(filelistgt,filelisttmp);
		print("16spp",filelist16);
	if dir32:
		filelisttmp = os.listdir(dir32);
		filelisttmp = fixlist(filelisttmp,12);
		filelist32 = compare(filelistgt,filelisttmp);
		print("32spp",filelist32);
	if dir64:
		filelisttmp = os.listdir(dir64);
		filelisttmp = fixlist(filelisttmp,12);
		filelist64 = compare(filelistgt,filelisttmp);
		print("64spp",filelist64);




