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
	
	gtdir = "E:\\datasetcombine\\GT"
	dir8 = "E:\\datasetcombine\\8SPP"
	dir16 = "E:\\datasetcombine\\16SPP"
	dir32 = "E:\\datasetcombine\\32SPP"
	dir64 = "E:\\datasetcombine\\64SPP"

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




