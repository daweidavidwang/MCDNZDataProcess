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
	spp4 = 0;
	spp8 = 0;
	spp16 = 0;
	spp32 = 0;
	spp64 = 0;
	same = 1;

	gtdir = "I:\\DatasetWithSecondFeature_aug3\\val&testSet_0728_jpg\\"
	dir4 = "E:\\dataset\\RD\\4spp\\exr\\"
	dir8 = "E:\\dataset\\RD\\8spp\\exr\\"
	dir16 = "E:\\dataset\\RD\\16spp\\exr\\"
	dir32 = "E:\\dataset\\RD\\32spp\\exr\\"
	dir64 = "E:\\dataset\\RD\\64spp\\exr\\"
	dirs = "I:\\DatasetWithSecondFeature_aug3\\GT\\"
	de4 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareRD\\4SPP\\"
	de8 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareRD\\8SPP\\"
	de16 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareRD\\16SPP\\"
	de32 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareRD\\32SPP\\"
	de64 = "G:\\DatasetWithSecondFeature_aug2\\TestSetSSCompareRD\\64SPP\\"
	des = "I:\\DatasetWithSecondFeature_aug3\\testSet_0728\\"
	filelistgt = [];
	filelist8 = [];
	filelist16 = [];
	filelist32 = [];
	filelist64 = [];
	filelisttmp = [];
	filelistsame = [];
	filelistgt = os.listdir(gtdir);
	filelistgt = fixlist(filelistgt,4);
	print(filelistgt);
	if spp4:
		for i in filelistgt:
			pathtmp1 = dir4+i+"_flt.exr"
			pathtmp2 = de4+i+"_MC0004_RD.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp8:
		for i in filelistgt:
			pathtmp1 = dir8+i+"_flt.exr"
			pathtmp2 = de8+i+"_MC0008_RD.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp16:
		for i in filelistgt:
			pathtmp1 = dir16+i+"_flt.exr"
			pathtmp2 = de16+i+"_MC0016_RD.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp32:
		for i in filelistgt:
			pathtmp1 = dir32+i+"_flt.exr"
			pathtmp2 = de32+i+"_MC0032_RD.exr"
			copyfile(pathtmp1,pathtmp2)
	if spp64:
		for i in filelistgt:
			pathtmp1 = dir64+i+"_flt.exr"
			pathtmp2 = de64+i+"_MC0064_RD.exr"
			copyfile(pathtmp1,pathtmp2)
	if same:
		for i in filelistgt:
			pathtmp1 = dirs+i+".exr"
			pathtmp2 = des+i+".exr"
			print(pathtmp1);
			print(pathtmp2);
			copyfile(pathtmp1,pathtmp2)



