import os
import shutil


path_patients='/media/roger/48BCFC2BBCFC1562/dataset/BMD_OESO_BDD_30_60'

path_dest='/media/roger/48BCFC2BBCFC1562/dataset/CT_30_60_cleaned'


_, patients, _ = os.walk(path_patients).next()#every folder is a patient 

for idx,patient in enumerate(patients):
	ctdata=os.path.join(path_patients,patient,patient+'.nii.gz')
	gtdata=os.path.join(path_patients,patient,'GT.nii.gz')
	contour=os.path.join(path_patients,patient,'CONTOUR.nii.gz')
	dirsave=os.path.join(path_dest,patient)

	ctdest=os.path.join(dirsave,patient+'.nii.gz')
	gtdest=os.path.join(dirsave,'GT.nii.gz')
	contourdest=os.path.join(dirsave,'CONTOUR.nii.gz')
	if not os.path.exists(dirsave):
		os.makedirs(dirsave)
	shutil.copyfile(ctdata, ctdest)
	shutil.copyfile(gtdata, gtdest)
	shutil.copyfile(contour, contourdest)

	print patient+' done'