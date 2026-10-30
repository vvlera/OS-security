Лабораторная работа № 3

2.1.1
mkdir ~/test
cd ~/test
touch file
ls -l file

2.1.2
chmod 000 file
echo "hello" > file
cat file

2.1.3
chmod 200 file
echo "hello" > file
cat file

2.1.4
chmod g+r file
cat file

2.1.5
chmod u+r file
cat file

2.1.6
mkdir dir
echo "test string" > dir/new_file
ls -l dir

2.1.7
chmod a-x dir
ls -l dir
cat dir/new_file
rm dir/new_file
chmod u+x dir

2.1.8
chown root file

2.1.9
umask 077
touch f_private
ls -l f_private

2.1.10
umask 000
touch f_public
ls -l f_public
umask 002

2.1.11
sudo passwd root
su
chown root /home/uim/test/file
chmod 400 /home/uim/test/file
ls -l /home/uim/test/file
exit

2.1.12
cat ~/test/file
sudo chmod 440 /home/uim/test/file
cat ~/test/file

2.2.1
whoami
id
groups

2.2.2
grep "^uim:" /etc/passwd
getent group uim

2.2.3
sudo groupadd labgroup
getent group labgroup

2.2.4
sudo useradd -m -s /bin/bash labuser
getent passwd labuser
id labuser

2.2.5
sudo passwd labuser
su - labuser
whoami
id
pwd
exit

2.2.6
su - labuser
touch ~/myfile
ls -l ~/myfile
exit

2.2.7
sudo usermod -aG labgroup labuser
id labuser
su - labuser
id
exit

2.2.8
sudo useradd -m -s /bin/bash -G labgroup labuser2
sudo passwd labuser2
getent group labgroup
id labuser
id labuser2

2.2.9
sudo mkdir /tmp/lab_shared
sudo chgrp labgroup /tmp/lab_shared
sudo chmod 770 /tmp/lab_shared
ls -ld /tmp/lab_shared
sudo -u labuser touch /tmp/lab_shared/a1
sudo -u labuser2 touch /tmp/lab_shared/a2

2.2.10
sudo -u labuser bash -c 'echo data > /tmp/lab_shared/f1'
sudo ls -l /tmp/lab_shared/f1
sudo -u labuser2 cat /tmp/lab_shared/f1
sudo -u labuser2 bash -c 'echo x >> /tmp/lab_shared/f1'
sudo -u labuser2 rm -f /tmp/lab_shared/f1

2.2.11
sudo chmod g+s /tmp/lab_shared
sudo -u labuser touch /tmp/lab_shared/s1
sudo -u labuser2 touch /tmp/lab_shared/s2
sudo ls -l /tmp/lab_shared
ls -ld /tmp/lab_shared

2.2.12
sudo mkdir /tmp/sticky_dir
sudo chmod 1777 /tmp/sticky_dir
sudo -u labuser touch /tmp/sticky_dir/u1
sudo -u labuser2 touch /tmp/sticky_dir/u2
sudo -u labuser2 rm -f /tmp/sticky_dir/u1

2.2.13
sudo usermod -L labuser
sudo passwd -S labuser
su - labuser
sudo usermod -U labuser
sudo passwd -S labuser
su - labuser
exit

2.2.14
sudo chage -l labuser
sudo chage -d 0 labuser
sudo chage -l labuser
su - labuser
exit

2.2.15
sudo usermod -s /bin/sh labuser
grep '^labuser:' /etc/passwd
sudo usermod -s /bin/bash labuser
grep '^labuser:' /etc/passwd

2.2.16
sudo -u labuser2 touch /home/labuser2/keep_me
sudo userdel labuser2
ls -la /home/labuser2

2.2.17
cat /etc/passwd
grep -E '^(daemon|bin|www-data|syslog|uim):' /etc/passwd

2.2.18
grep -E 'UID_(MIN|MAX)' /etc/login.defs
awk -F: '$3>=1000 && $3<=60000 {print $1, $3}' /etc/passwd
awk -F: '$3>=100 && $3<=999 {print $1, $3}' /etc/passwd

2.2.19
sudo useradd -m -s /bin/bash testuser
sudo useradd -r testsystem
getent passwd testuser testsystem
ls -ld /home/testuser /home/testsystem

2.2.20
sudo userdel testsystem
sudo useradd -r -m testsystem
ls -ld /home/testsystem

2.2.21
grep -E '(nologin|false)$' /etc/passwd
command -v nologin false
man nologin

2.2.22
sudo passwd testuser
sudo usermod -s /usr/sbin/nologin testuser
su - testuser
sudo -u testuser id

2.2.23
sudo usermod -s /bin/false testuser
su - testuser
echo $?

2.2.24
sudo usermod -s /bin/bash testuser
su - testuser
exit

2.2.25
sudo usermod -s /usr/bin/date testuser
su - testuser
sudo usermod -s /bin/bash testuser

2.2.26
sudo groupadd -r testsystemgroup
sudo groupadd testgroup
getent group testsystemgroup testgroup

2.2.27
grep -E 'GID_(MIN|MAX)' /etc/login.defs

2.2.28
sudo useradd -r -g testsystemgroup -M -s /usr/sbin/nologin serviceuser
grep '^serviceuser:' /etc/passwd

2.2.29
su - testuser
sudo id
exit

2.2.30
sudo visudo -f /etc/sudoers.d/testuser
testuser ALL=(root) /usr/bin/id
su - testuser
sudo id
sudo whoami
exit

2.2.31
sudo visudo -f /etc/sudoers.d/testuser
testuser ALL=(root) /usr/bin/id, /usr/bin/apt update
su - testuser
sudo id
sudo apt update
sudo apt install htop
exit

2.2.32
sudo rm /etc/sudoers.d/testuser
sudo groupadd testadmins
sudo visudo -f /etc/sudoers.d/testadmins
%testadmins ALL=(root) /usr/bin/apt
2.2.33
sudo cp /etc/login.defs /etc/login.defs.orig
sudo cp /etc/default/useradd /etc/default/useradd.orig
grep -vE '^\s*(#|$)' /etc/login.defs

2.2.34
awk -F: '$3>=5000 && $3<=60000' /etc/passwd
sudo sed -i 's/^UID_MIN.*/UID_MIN\t\t\t 5000/' /etc/login.defs
grep '^UID_MIN' /etc/login.defs
sudo useradd configuser1
id configuser1
sudo userdel -r configuser1
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.35
awk -F: '$3>=800 && $3<=810' /etc/passwd /etc/group
echo -e "SYS_UID_MIN 800\nSYS_UID_MAX 810" | sudo tee -a /etc/login.defs
sudo useradd -r sysconfig1
sudo useradd -r sysconfig2
sudo useradd -r sysconfig3
grep '^sysconfig' /etc/passwd
sudo userdel sysconfig1
sudo userdel sysconfig2
sudo userdel sysconfig3
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.36
awk -F: '$3>=6000 && $3<=6100' /etc/group
sudo sed -i -e 's/^GID_MIN.*/GID_MIN\t\t\t 6000/' -e 's/^GID_MAX.*/GID_MAX\t\t\t 6100/' /etc/login.defs
sudo groupadd configgroup1
getent group configgroup1
sudo groupdel configgroup1
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.37
awk -F: '$3>=850 && $3<=860' /etc/group
echo -e "SYS_GID_MIN 850\nSYS_GID_MAX 860" | sudo tee -a /etc/login.defs
sudo groupadd -r sysgrp1
sudo groupadd -r sysgrp2
sudo groupadd -r sysgrp3
grep '^sysgrp' /etc/group
sudo groupdel sysgrp1
sudo groupdel sysgrp2
sudo groupdel sysgrp3
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.38
grep -n 'CREATE_HOME' /etc/login.defs
echo "CREATE_HOME yes" | sudo tee -a /etc/login.defs
sudo useradd homeuser1
ls -ld /home/homeuser1
sudo sed -i 's/^CREATE_HOME.*/CREATE_HOME no/' /etc/login.defs
sudo useradd homeuser2
ls -ld /home/homeuser2
sudo userdel -r homeuser1
sudo userdel homeuser2
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.39
echo "CREATE_HOME yes" | sudo tee -a /etc/login.defs
sudo useradd -r syshome1
ls -ld /home/syshome1
sudo useradd -r -m syshome2
ls -ld /home/syshome2
sudo userdel syshome1
sudo userdel -r syshome2
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.40
grep -E 'UMASK|HOME_MODE' /etc/login.defs
sudo useradd -m modeuser1
stat -c '%a %n' /home/modeuser1
sudo sed -i 's/^HOME_MODE.*/HOME_MODE\t0700/' /etc/login.defs
sudo useradd -m modeuser2
stat -c '%a %n' /home/modeuser1 /home/modeuser2
sudo userdel -r modeuser1
sudo userdel -r modeuser2
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.41
grep '^USERGROUPS_ENAB' /etc/login.defs
sudo useradd ugroupuser1
getent group ugroupuser1
id ugroupuser1
sudo sed -i 's/^USERGROUPS_ENAB.*/USERGROUPS_ENAB no/' /etc/login.defs
sudo useradd ugroupuser2
getent group ugroupuser2
id ugroupuser2
sudo userdel ugroupuser1
sudo userdel ugroupuser2
sudo cp /etc/login.defs.orig /etc/login.defs

2.2.42
sudo useradd -D
sudo useradd -D -s /bin/bash
sudo useradd defaultuser1
grep '^defaultuser1:' /etc/passwd

2.2.43
sudo mkdir -p /srv/home
sudo useradd -D -b /srv/home
sudo useradd -m defaultuser2
grep '^defaultuser2:' /etc/passwd
ls -ld /srv/home/defaultuser2
