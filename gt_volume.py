# -*- coding: utf-8 -*-
"""
Created on Thu Nov 26 14:14:01 2015

@author: rogertrullo
"""

import SimpleITK as sitk
import os 
#import thresholding1 as thr




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
            sitk.WriteImage( volume, os.path.join(dirpatients,patients[i],namefolders[j]+'.nii.gz') )
            print patients[i]+" done"
            
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
            
            

if __name__ == '__main__':
    #namefolders=['BMD-Esophagus','BMD-Aorta','BMD-Heart','BMD-Trachea']
    dirpatients='/Users/trullro/Downloads/patient_test/'
    #dicom2nii(dirpatients)
    namefolders=['GT']
    pngs2nii(dirpatients,namefolders)
