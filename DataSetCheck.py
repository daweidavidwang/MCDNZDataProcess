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
	spp8 = 0;
	spp16 = 0;
	spp32 = 0;
	spp64 = 0;
	same = 1;

	gtdir = "G:\\DatasetWithSecondFeature_aug2\\GT"
	dir8 = "F:\\dataset1_var_train\\4spp"
	dir16 = "F:\\dataset1_var_train\\8spp"
	dir32 = "F:\\dataset1_var_train\\16spp"
	dir64 = "F:\\dataset1_var_train\\32spp"
	dirsame = "G:\\DatasetWithSecondFeature_aug2\\check"

	filelistgt = [];
	filelist8 = [];
	filelist16 = [];
	filelist32 = [];
	filelist64 = [];
	filelisttmp = [];
	filelistsame = [];
	filelistgt = os.listdir(gtdir);
	filelistgt = fixlist(filelistgt,4);
	if spp8:
		filelisttmp = fixlist(filelisttmp,12);
		filelist8 = compare(filelistgt,filelisttmp);
		print("8spp",filelist8);
	if spp16:
		filelisttmp = os.listdir(dir16);
		filelisttmp = fixlist(filelisttmp,12);
		filelist16 = compare(filelistgt,filelisttmp);
		print("16spp",filelist16);
	if spp32:
		filelisttmp = os.listdir(dir32);
		filelisttmp = fixlist(filelisttmp,12);
		filelist32 = compare(filelistgt,filelisttmp);
		print("32spp",filelist32);
	if spp64:
		filelisttmp = os.listdir(dir64);
		filelisttmp = fixlist(filelisttmp,12);
		filelist64 = compare(filelistgt,filelisttmp);
		print("64spp",filelist64);
	if same:
		filelisttmp = os.listdir(dirsame);
		filelisttmp = fixlist(filelisttmp,4);
		filelistsame = compare(filelistgt,filelisttmp);
		print("same",filelistsame);




