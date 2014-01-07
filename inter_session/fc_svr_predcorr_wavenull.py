from numpy import array,corrcoef,zeros,double,nonzero
from scipy.io import savemat
import os
import re

censors=["censor1","censor2","censor3","censor4"]
#censors=["censor4"]
#censors=["censor_MSIT"]
#odsets=["REST1","REST2"]
odsets=["REST1","REST2"]
#pdsets=["REST1","REST2","MSIT1","MSIT2"]
pdsets=["REST1","REST2"]
tc_postfix='.1D'

path,id=os.path.split(os.getcwd())
m=re.search('CCB(\d+)_scan(\d+)_(\d+)',id)
#print id,m.group(0),m.group(1),m.group(2),m.group(3)
subjnum=m.group(1)
scannum=m.group(2)
scandate=m.group(3)

e=open(id+'_wavenull_empty_files.txt','wa')
for censor in censors:
	predR=zeros([6, 179],'double')
	predC=zeros([6, 179],'double')
	exp_var=zeros([6, 179],'double')
        count=0
	
	for odset in odsets:
		predtc_prefix=path+'/'+id+'/'+censor+'_'+odset+'_wavenull/swnmrdaCCB'+\
			subjnum+'_scan'+scannum+'_'+odset+'_'+scandate+\
			'_wavenull_pred_CCB'+subjnum+'_scan'+scannum+'_'
		print predtc_prefix
		print censor+"_"+odset

		for pdset in pdsets:
			if pdset != odset:
				pdset_prefix=predtc_prefix+pdset+'_'
				odset_prefix=path+'/'+id+'/'+pdset+'_obs_TCs/'+'swnmrdaCCB'+\
					subjnum+'_scan'+scannum+'_'+pdset+'_TCs_'

				#for num in range(1,2):
				for num in range(1,180):
					#print num

					## load in the predicted TC
					ptc_file=pdset_prefix+str(num)+tc_postfix
					try:
						f=open(ptc_file)
					except IOError:
						e.write("ioerr:"+ptc_file+'\n')
						continue
					pred_tc=[]
					for line in f:
						if line.find("#") == -1:
							pred_tc.append(double(line))

					f.close()
					pred_tc=array(pred_tc)

					## load in the observed TC
					otc_file=odset_prefix+str(num)+tc_postfix
					try:
						f=open(otc_file)
					except IOError:
						e.write("ioerr:"+otc_file+'\n')
						continue
					
					obs_tc=[]
					for line in f:
						if line.find("#") == -1:
							obs_tc.append(double(line))

					f.close()
					obs_tc=array(obs_tc)

					if len(pred_tc) != len(obs_tc):
						e.write("length:"+ptc_file+otc_file+'\n')
						continue

					if len(nonzero(pred_tc)[0])==0:
						e.write("zeros:"+ptc_file+'\n')
						continue

					if len(nonzero(obs_tc)[0])==0:
						e.write("zeros:"+obs_file+'\n')
						continue

					predR[count,num-1]=corrcoef(pred_tc,obs_tc)[0,1]
					predC[count,num-1]=(2*predR[count,num-1]*pred_tc.std(0)*obs_tc.std(0))/\
						(pred_tc.var(0)+obs_tc.var(0)+\
						(pred_tc.mean(0)-obs_tc.mean(0))**2)
					residuals=(obs_tc-pred_tc)
					exp_var[count,num-1]=(residuals*residuals).mean(0)/obs_tc.var(0)
					#print predR[count,num-1],predC[count,num-1]

				count=count+1
				#print count
	data={}
	data['predR']=predR
	data['predC']=predC
	data['exp_var']=exp_var
	savemat(path+'/'+id+'/'+id+'_'+censor+'_wavenull_pred.mat',data)

e.close()
