#!/bin/sh

WorkingDirectory="/home/denbo3/ayumu/JobThrower" # Location of Subject folders (named by subjectID)
job_dir=${WorkingDirectory}/job
script_output=${WorkingDirectory}/out
mkdir -p ${job_dir}
mkdir -p ${script_output}

num_repeat=({1..100})

for run_num in ${num_repeat[@]}; do
echo "#!/bin/sh" >${job_dir}/job${run_num}.sh
echo "#PBS -M ayumu@atr.jp" >>${job_dir}/job${run_num}.sh
echo "#PBS -m e" >>${job_dir}/job${run_num}.sh
echo "#PBS -j oe" >>${job_dir}/job${run_num}.sh
echo "#PBS -o ${script_output}" >>${job_dir}/job${run_num}.sh
echo "sleep 60" >>${job_dir}/job${run_num}.sh
done
