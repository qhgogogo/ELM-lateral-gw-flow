export domainPath=/qfs/people/qiuh347/data/transect/
#export domainFile=domain_100unique_c220504.nc
#export surfdataFile=surfdata_100unique_c220504.nc
export domainFile=domain_180unique_c220607.nc
export surfdataFile=surfdata_180unique_c220607.nc


export RES=ELM_USRDAT
export COMPSET=IELM
export COMPILER=intel
export MACH=compy
export CASE_NAME=transect_3d_vshape_rerun_10k

cd ~/E3SM_lateral_nosatGW_3d_converge_sat15/cime/scripts
module purge
./create_newcase -compset ${COMPSET} -res ${RES} -case ${CASE_NAME} -compiler ${COMPILER} -mach ${MACH} -project ESMD
cd ${CASE_NAME}
./xmlchange LND_DOMAIN_FILE=${domainFile}
./xmlchange ATM_DOMAIN_FILE=${domainFile}
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}
./xmlchange NTASKS=1,STOP_N=8,STOP_OPTION=nmonths,JOB_WALLCLOCK_TIME="02:00:00",RUN_STARTDATE="2000-05-01",REST_N=12,REST_OPTION=nmonths
./xmlchange DATM_MODE="CLMGSWP3v1",DATM_CLMNCEP_YR_START='2000',DATM_CLMNCEP_YR_END='2010'
cat >> user_nl_elm << EOF
hist_empty_htapes           = .true.
hist_fincl1                 ='QSNOMELT','TSOI_10CM','ZWT','H2OSOI','TSOI','FSH','EFLX_LH_TOT','SMP'
hist_nhtfrq                 = -1,1
hist_mfilt                  = 24,48
fsurdat                     = '${domainPath}${surfdataFile}'
EOF
./case.setup
./case.build
./case.submit


