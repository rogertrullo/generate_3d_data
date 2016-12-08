'''
Created on Jul 11, 2016

@author: roger
'''
import os
import shutil
dir_data='/media/roger/48BCFC2BBCFC1562/dataset/BMD_OESO_BDD_30_60'

path, patients, _ = os.walk(dir_data).next()#every folder is a patient

for patient in patients:
    dir_dest=os.path.join(path,patient)
    
    _, folders_tmp, _=os.walk(dir_dest).next()#every folder is a patient
    print patient, folders_tmp
    if len(folders_tmp)==1:
        pathsrc, foldersctrt, _ = os.walk(os.path.join(dir_dest,folders_tmp[0])).next()
    else:
        
        print patient+' skipped do maually'
        continue
        
    if len(foldersctrt)!=2:
        print patient, ' this folder contains more than 2 folders do it manually'
        continue
    else:
        pass#print patient
    
    
    skippatient=False
    for i in foldersctrt:
        
        if 'ct' in i.lower() or 'rt' in i.lower() or 'cria' in i.lower():
            pass
        elif 'structures' in i.lower():
            pass
        else:
            skippatient=True   
    if skippatient:
        print patient+' skipped do maually'
        continue
    print foldersctrt
    for i in foldersctrt:
        
        if 'crai' in i.lower() or 'thorax'in i.lower() or 'ct tap'in i.lower() or 'ct_tap'in i.lower() or '120kv'in i.lower():
            shutil.move(os.path.join(pathsrc,i), os.path.join(dir_dest,'CT'))
            #os.rename(os.path.join(dir_dest,i), os.path.join(dir_dest,'CT'))
            print patient, i+' is the ct folder'
        elif 'structure' in i.lower():
            shutil.move(os.path.join(pathsrc,i), os.path.join(dir_dest,'RTstruct'))
        else:
            print 'error in '+patient
            continue
        print patient, 'succesfully changed'
            
    shutil.rmtree(pathsrc)      
    