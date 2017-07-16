#header MCDnoising IMDB logfile Generater
#author David Wang
import os
import os.path
if __name__ == "__main__":
	mode = 1
	logfile = 'E:\\imdb_HDR00001.txt'
	datasetdir = 'E:\\datasetcombine\\GT\\'
	desdir = 'E:\\datasetcombine\\gto'
	if mode == 0: 
		file_object  = open(logfile);
		try:
			all_the_text = file_object.read();
		finally:
			file_object.close();
		print(all_the_text);
		all_the_text=all_the_text.split();
		for i in all_the_text:
			print(i);
			os.system("copy %s %s" %(datasetdir+i,desdir+i))
	elif mode == 1:
		file_object  = open(logfile,"w");
		filelist = [];
		filelist = os.listdir(desdir);
		print(filelist);
		for i in filelist:
			file_object.write(i+"\n");
		file_object.close;

