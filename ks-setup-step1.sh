# Added by ssennett (ACG 2021-12-20)
# Throws an error if the script is running outside of root privs
if [ "$EUID" -ne 0 ]
  then echo "ERROR: Not running as root! You'll need to \`sudo su\` before running this script"
  exit
fi

chmod +x ./*.sh &>> ./setup-step1.out
echo "1...\n" >> ./setup-step1.out
./turn_off_selinux.sh &>> ./setup-step1.out
echo "12...\n" >> ./setup-step1.out
./turn_off_swap.sh &>> ./setup-step1.out
echo "123...\n" >> ./setup-step1.out
./set_up_bridging.sh &>> ./setup-step1.out
echo "1234\n" >> ./setup-step1.out
cp ./kubernetes.repo /etc/yum.repos.d/kubernetes.repo &>> ./setup-step1.out
echo "Rebooting now...\n" >> ./setup-step1.out
reboot
