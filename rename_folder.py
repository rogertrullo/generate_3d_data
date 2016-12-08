import os
import shutil
dir_data='/media/roger/48BCFC2BBCFC1562/dataset/BMD_OESO_BDD_30_60'

path, patients, _ = os.walk(dir_data).next()#every folder is a patient

for patient in patients:
	print patient
	dir_dest=os.path.join(path,patient)
	_, folders_tmp, _=os.walk(dir_dest).next()#every folder is a patient
	pathsrc, foldersrc, _ = os.walk(os.path.join(dir_dest,folders_tmp[0])).next()
	#print folders_tmp
	if 'CONTOUR EXTERNE' in  folders_tmp:
		shutil.move(os.path.join(dir_data,patient,'CONTOUR EXTERNE'), os.path.join(dir_data,patient,'body'))
		print patient, ' changed'



