#!/bin/bash

if [ $USER != 'root' ]; then
	echo "ขออภัยคุณต้องเรียกการใช้งานนี้เป็น root"
	exit
fi
cd

clear
echo "--------- OCS Panels Installer for Debian -----------"
echo ""
echo ""
echo "ยินดีต้อนรับสู่ Osc Panel Auto Script BY URBOY VPN"
echo "คุณสามารถใช้ข้อมูลของตัวเองได้เพียงแค่ กดลบ หรือ กด Enter ถ้าคุณเห็นด้วยกับข้อมูลของเรา"
echo ""
echo "1.ตั้งรหัสผ่านใหม่สำหรับ user root MySQL:"
read -p "Password ใหม่: " -e -i ampol1992 DatabasePass
echo ""
echo "2.ตั้งค่าชื่อฐานข้อมูลสำหรับ OCS Panels"
echo "โปรดใช้ตัวอัพษรปกติเท่านั้นห้ามมีอักขระพิเศษอื่นๆที่ไม่ใช่ขีดล่าง (_)"
read -p "Name Database: " -e -i urboyvpn DatabaseName
echo ""
echo "เอาล่ะนี่คือทั้งหมดที่ระบบ Ocs Script ต้องการ เราพร้อมที่จะติดตั้งแผง OCS ของคุณแล้ว"
read -n1 -r -p "กดปุ่ม Enter เพื่อดำเนินการต่อ ..."


apt-get -y update && apt-get -y upgrade

apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

wget https://adlottomm.000webhostapp.com/webmin_1.831_all.deb

dpkg --install webmin_1.831_all.deb

sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

rm -f webmin_1.831_all.deb

/usr/share/webmin/changepass.pl /etc/webmin root ninjanum

service webmin restart

apt-get update && apt-get -y install mysql-server

mysql_secure_installation

chown -R mysql:mysql /var/lib/mysql/ && chmod -R 755 /var/lib/mysql/

apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup
wget -O /etc/nginx/nginx.conf "https://adlottomm.000webhostapp.com/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://adlottomm.000webhostapp.com/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m vps && mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html && echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html && chmod -R g+rw /home/vps/public_html
service php5-fpm restart && service nginx restart

mysql -u root -p

apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/dathai/SSH-OpenVPN/master/API/squid3.conf"

service squid3 restart

chmod -R 777 /home/vps/public_html
echo ""
read -p "ใส่ไฟล์ urboyvpn.zip ใน /home/vps/public_html กดปุ่ม [Enter] เพื่อดำเนินการต่อ ..."

apt-get -y install zip unzip
cd /home/vps/public_html
unzip sernoomzeocs.zip
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini

cd
chmod -R 777 /home/vps/public_html

clear
echo ""
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo ""
echo "เปิดเบราว์เซอร์และเข้าถึงที่อยู่ http://$MYIP:85/ และกรอกข้อมูล 2 ด้านล่าง!"
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: urboyvpn"
echo "- Database User: root"
echo "- Database Pass: ampol1992"
echo ""

echo "คลิกติดตั้งและรอให้กระบวนการเสร็จสิ้นจากนั้นปิด Browser และกลับมาที่นี่ (Putty) แล้วกด [ENTER]!"

sleep 3
echo ""
read -p "หากขั้นตอนข้างต้นเสร็จสิ้นโปรดกดปุ่ม [Enter] เพื่อดำเนินการต่อ ..."
echo ""
read -p "หากคุณเชื่อว่าขั้นตอนข้างต้นได้ทำเสร็จแล้วโปรดกดปุ่ม [Enter] เพื่อดำเนินการต่อ ..."
echo ""

rm -R /home/vps/public_html/installation

# info
clear
echo "=======================================================" | tee -a log-install.txt
echo "กรุณาเข้าสู่ระบบ OCS Panel ที่ http://$MYIP:85/" | tee -a log-install.txt

#echo "" | tee -a log-install.txt
#echo "บันทึกการติดตั้ง --> /root/log-install.txt" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "โปรดรีบูต VPS ของคุณ!" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
cd ~/
