#!/bin/sh

WorkingDirectory="/home/denbo3/ayumu/JobThrower" # Location of Subject folders (named by subjectID)
username="ayumu"
job_dir=${WorkingDirectory}/job
job_files=$(ls -U1 $job_dir)
job_num=$(ls -U1 $job_dir | wc -l)

if [ "$(uname -n)" == "pine01" ];then
NODENAME="pine"
NODE=({02..16})
FIRSATNODE=02
CORENUM=8
NUMNODE=15
MAXJOB=96
elif [ "$(uname -n)" == "beers" ];then
NODENAME="cns-node"
NODE=({01..16})
FIRSATNODE=01
CORENUM=24
NUMNODE=16
MAXJOB=36
fi

function find_usenode {
for i in ${NODE[@]};do
if [ ${i} == ${FIRSATNODE} ];then
COUNT_PRE=$(qstat -nr | grep -c ${NODENAME}${i})
use_node=${i}
else
COUNT_NOW=$(qstat -nr | grep -c ${NODENAME}${i})
if [ ${COUNT_NOW} -lt ${COUNT_PRE} ];then
COUNT_PRE=${COUNT_NOW}
use_node=${i}
fi
fi
done
}

echo Now job throw
for job in ${job_files[@]}; do
current_job_num=$(qstat | grep ${username} | wc -l)
find_usenode
while test  ${COUNT_PRE} -eq ${CORENUM} -o ${current_job_num} -eq ${MAXJOB}; do
echo "*"
sleep 10
current_job_num=$(qstat | grep ${username} | wc -l)
find_usenode
done
qsub -l nodes=${NODENAME}${use_node}:ppn=1 ${job_dir}/${job}
echo Throw ${job} in ${NODENAME}${use_node}
done

echo "done!!"