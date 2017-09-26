#header MCDnoising
#author David Wang
#Copy the same-name file
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

def copyfile(filepath1,filepath2):
	os.system ("copy %s %s" % (filepath1, filepath2))

if __name__ == "__main__":
	spp4 = 1;
	spp8 = 1;
	spp16 = 1;
	spp32 = 1;
	spp64 = 1;
	same = 0;

	gtdir = "G:\\DatasetWithSecondFeature_aug2\\TestSetSS\\"
	dir4 = "E:\\datasetcombine\\4SPP\\LBF\\"
	dir8 = "E:\\datasetcombine\\8SPP\\LBF\\"
	dir16 = "E:\\datasetcombine\\16SPP\\LBF\\"
	dir32 = "E:\\datasetcombine\\32SPP\\LBF\\"
	dir64 = "E:\\datasetcombine\\64SPP\\LBF\\"
	de4 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareLBF\\4SPP\\"
	de8 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareLBF\\8SPP\\"
	de16 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareLBF\\16SPP\\"
	de32 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareLBF\\32SPP\\"
	de64 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareLBF\\64SPP\\"

	filelistgt = [];
	filelist8 = [];
	filelist16 = [];
	filelist32 = [];
	filelist64 = [];
	filelisttmp = [];
	filelistsame = [];
	filelistgt = os.listdir(gtdir);
	filelistgt = fixlist(filelistgt,4);
	if spp4:
		for i in filelistgt:
			pathtmp1 = dir4+i+"_LBF_flt.exr"
			pathtmp2 = de4+i+"_MC0004_LBF.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp8:
		for i in filelistgt:
			pathtmp1 = dir8+i+"_LBF_flt.exr"
			pathtmp2 = de8+i+"_MC0008_LBF.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp16:
		for i in filelistgt:
			pathtmp1 = dir16+i+"_LBF_flt.exr"
			pathtmp2 = de16+i+"_MC0016_LBF.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp32:
		for i in filelistgt:
			pathtmp1 = dir32+i+"_LBF_flt.exr"
			pathtmp2 = de32+i+"_MC0032_LBF.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp64:
		for i in filelistgt:
			pathtmp1 = dir64+i+"_LBF_flt.exr"
			pathtmp2 = de64+i+"_MC0064_LBF.exr"
			copyfile(pathtmp1,pathtmp2)
	if same:
		filelisttmp = os.listdir(dirsame);
		filelisttmp = fixlist(filelisttmp,4);
		filelistsame = compare(filelistgt,filelisttmp);
		print("same",filelistsame);




