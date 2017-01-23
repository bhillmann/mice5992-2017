cd
mv ~/.bashrc ~/old_bashrc
wget -O ~/.bashrc https://raw.githubusercontent.com/danknights/mice5992-2017/master/.bashrc
grep '^umask 027' -B 3 -A 2 ~/.bashrc > "/home/mice5992/dknights/setup_reports/$USER.txt"
source ~/.bashrc
echo ".................................................."
echo "Congratulations. You've just fixed your prompt. Probably."

cd
mkdir ~/Software
mkdir ~/QIIME_Workspace

wget -O ~/.qiime_config https://raw.githubusercontent.com/danknights/mice5992-2017/master/.qiime_config
wget -O ~/Software/make_MSI_cluster_jobs_itasca.py gabedev.com/3004/make_MSI_cluster_jobs_itasca.py
wget -O ~/Software/start_parallel_jobs_torque_MSI.py gabedev.com/3004/start_parallel_jobs_torque_MSI.py

sed -i.bak "s:/home/biol3004/tward:$HOME:g" ~/.qiime_config
echo "-------------------Contents:-------------------------"
grep -A2 "cluster_jobs_fp" ~/.qiime_config
grep -A2 "cluster_jobs_fp" ~/.qiime_config > "/home/mice5992/dknights/setup_reports/$USER-qiime_config.txt"
echo ""
echo "Congratulations. You've just enabled QIIME to see and use MSI's processors."
