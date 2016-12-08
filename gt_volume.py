# -*- coding: utf-8 -*-
"""
Created on Thu Nov 26 14:14:01 2015

@author: rogertrullo
"""

import SimpleITK as sitk
import os 
import numpy as np




def directory(path,extension):
    #list_dir = []
    list_dir = os.listdir(path)
    count = 0
    for fileidx in list_dir:
        if fileidx.endswith(extension): # eg: '.txt'
            count += 1
    return count
  
def list_png(nfiles,directory):
    listpng=[]
    for index in range(nfiles):
        listpng.append(os.path.join(directory,'%d'%(index+1)+'.png'))
    #listpng.reverse()
    return listpng


#===============================================================================
# INDIR='labels_data'
# DIRVOL='data'
# MAX_ID=15#max idx in the labels folders; in this case Oesophage01,....
# OUTDIR=INDIR
# #path, dirs, files = os.walk(INDIR).next()
# #dirs=directory(INDIR,'mha')
# reader = sitk.ImageSeriesReader()
# 
# for idx in range(MAX_ID+1):
#     
#     dirname=os.path.join(INDIR,'Oesophage%02d'%idx)
#     if not os.path.isdir(dirname):
#         print dirname+' not found'
#         continue   
#     file_count = directory(dirname,'png')
#     file_names=list_png(file_count,dirname)
#     reader.SetFileNames(file_names)
#     volume=reader.Execute()
#     reader = sitk.ImageSeriesReader()
#     image_name=os.path.join(DIRVOL,'test%02d'%(idx)+'.mha')
#     image=sitk.ReadImage(image_name)
#     volume.SetOrigin(image.GetOrigin())
#     volume.SetSpacing(image.GetSpacing())
#     volume.SetDirection(image.GetDirection())
#     gt_name = os.path.join(OUTDIR, 'label%02d'%idx+'.mha')
#     print 'saving '+gt_name
#     sitk.WriteImage( volume, gt_name )
# print 'All label volumes saved'
#===============================================================================


        

        
def pngs2nii(dirpatients,namefolders):
    """dirpatients is the directory that should include the CT folder
    namefolders is a list with the folders of the organs that contain pngs of the groundtruth
    named as 1.png 2.png ...."""
    print dirpatients
    _, patients, _ = os.walk(dirpatients).next()#every folder is a patient
    
    reader = sitk.ImageSeriesReader()
    for i in xrange(len(patients)):
        for j in xrange(len(namefolders)):
            npath=os.path.join(dirpatients,patients[i],namefolders[j])
            file_count = directory(npath,'png')
            file_names=list_png(file_count,npath)
            reader.SetFileNames(file_names)
            volume=reader.Execute()
            dicom_names = reader.GetGDCMSeriesFileNames( os.path.join(dirpatients,patients[i],'CT') )
            reader.SetFileNames(dicom_names)
            image = reader.Execute()  
            volume.SetOrigin(image.GetOrigin())
            volume.SetSpacing(image.GetSpacing())
            volume.SetDirection(image.GetDirection())
            label=namefolders[j]
            if namefolders[j]=='body':
                label='CONTOUR'
            sitk.WriteImage( volume, os.path.join(dirpatients,patients[i],label+'.nii.gz') )
            print patients[i],'_',namefolders[j],' done'
            
def dicom2nii(dirpatients):
#dirpatients must contain one folder for each patient. These folder must contain a folder
# named CT with the dicom data
    _, patients, _ = os.walk(dirpatients).next()#every folder is a patient
    reader = sitk.ImageSeriesReader()
    for i in xrange(len(patients)):    
        dicom_names = reader.GetGDCMSeriesFileNames( os.path.join(dirpatients,patients[i],'CT') )
        reader.SetFileNames(dicom_names)
        image = reader.Execute()           
        sitk.WriteImage( image, os.path.join(dirpatients,patients[i],patients[i]+'.nii.gz') )
        print patients[i]+" done"


def merge_labels(dirpatients):
    """
    Merge the labels in niftii files to one single file called GT.nii.gz

    """
    _, patients, _ = os.walk(dirpatients).next()#every folder is a patient

    for namepatient in patients:
        print namepatient
        im_eso=sitk.ReadImage(os.path.join(dirpatients,namepatient,'BMD-Esophagus'))
        im_heart=sitk.ReadImage(os.path.join(dirpatients,namepatient,'BMD-Heart'))
        im_trachea=sitk.ReadImage(os.path.join(dirpatients,namepatient,'BMD-Trachea'))
        im_aorta=sitk.ReadImage(os.path.join(dirpatients,namepatient,'BMD-Aorta'))

        im_eso_np=sitk.GetArrayFromImage(im_eso)
        idx_eso=np.where(im_eso_np>=1)
        im_heart_np=sitk.GetArrayFromImage(im_heart)
        idx_heart=np.where(im_heart_np>=1)
        im_trachea_np=sitk.GetArrayFromImage(im_trachea)
        idx_trach=np.where(im_trachea_np>=1)
        im_aorta_np=sitk.GetArrayFromImage(im_aorta)
        idx_aorta=np.where(im_aorta_np>=1)

        vol_final=np.zeros_like(im_eso_np,dtype=np.uint8)
        vol_final[idx_eso]=1
        vol_final[idx_heart]=2
        vol_final[idx_trach]=3
        vol_final[idx_aorta]=4

        vol_itk=sitk.GetImageFromArray(vol_final)
        vol_itk.SetOrigin(im_eso.GetOrigin())
        vol_itk.SetSpacing(im_eso.GetSpacing())
        vol_itk.SetDirection(im_eso.GetDirection())


        sitk.WriteImage(vol_itk,os.path.join(dirpatients,namepatient,'GT.nii.gz'))

        print namepatient,'done'








            
            

if __name__ == '__main__':
    #namefolders=['BMD-Esophagus','BMD-Heart','BMD-Trachea','BMD-Aorta']#This order will be saved the labels 1,2,3...
    namefolders=['body']
    dirpatients='/media/roger/48BCFC2BBCFC1562/dataset/BMD_OESO_BDD_30_60'
    #dicom2nii(dirpatients)
    #namefolders=['GT']
    pngs2nii(dirpatients,namefolders)
    #merge_labels(dirpatients)
