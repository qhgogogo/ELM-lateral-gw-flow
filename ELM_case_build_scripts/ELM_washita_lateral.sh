export domainPath=/qfs/people/qiuh347/data/
export domainFile=domain_washita50x35u2_c221228.nc
export surfdataFile=surfdata_washita50x35u2_c221228.nc
export RES=ELM_USRDAT
export COMPSET=IELM
export COMPILER=intel
export MACH=compy
export CASE_NAME=washita_default_lat_newf66
SRC_DIR=~/E3SM_lateral_walnut_copy
CASE_DIR=${SRC_DIR}/cime/scripts
cd ~/E3SM_lateral_walnut_copy/cime/scripts
#cd ~/E3SM/cime/scripts
module purge
./create_newcase -compset ${COMPSET} -res ${RES} -case ${CASE_NAME} -compiler ${COMPILER} -mach ${MACH} -project ESMD
cd ${CASE_NAME}

./xmlchange LND_DOMAIN_FILE=${domainFile}
./xmlchange ATM_DOMAIN_FILE=${domainFile}
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}
./xmlchange NTASKS=1,STOP_N=1200,STOP_OPTION=nmonths,JOB_WALLCLOCK_TIME="40:00:00",RUN_STARTDATE="2008-01-01",REST_N=24,REST_OPTION=nmonths
./xmlchange DATM_MODE=CLMMOSARTTEST,DATM_CLMNCEP_YR_START='2008',DATM_CLMNCEP_YR_END='2008'
cat >> user_nl_elm << EOF
hist_empty_htapes           = .true.
hist_fincl1                 ='FSDS','TSOI_10CM','ZWT','H2OSOI','TSOI','FSH','EFLX_LH_TOT','QVEGE','QVEGT','QSOIL','QFLX_EVAP_TOT','QOVER','QDRAI','QDRAI_XS'
hist_nhtfrq                 = -1,1
hist_mfilt                  = 24,48
fsurdat                     = '${domainPath}${surfdataFile}'
EOF

./case.setup
./case.build
./case.submit
