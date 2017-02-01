FROM debian:wheezy-slim

MAINTAINER Nekrasov Alexander <snake_nas@mail.ru>

ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server 
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
       bc:i386 \
       libaio1:i386 \
       libc6-i386 \
       net-tools \
       openssh-server \
	     wget && \
    apt-get clean && \
    mkdir /var/run/sshd && \
    echo 'root:admin' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
	  wget --no-check-certificate --quiet https://oss.oracle.com/debian/dists/unstable/non-free/binary-i386/oracle-xe_10.2.0.1-1.1_i386.deb && \
    dpkg -i oracle-xe_10.2.0.1-1.1_i386.deb && \
    rm oracle-xe_10.2.0.1-1.1_i386.deb && \
    sed -i 's/51200K/4096K/' /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/config/scripts/cloneDBCreation.sql && \        
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure && \
    echo 'export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server' >> /etc/bash.bashrc && \
    echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc && \
    echo 'export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252' >> /etc/bash.bashrc && \
    echo '#!/bin/sh' > /bin/startdb && \
    echo 'sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/network/admin/listener.ora' >> /bin/startdb && \
    echo 'sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/network/admin/tnsnames.ora' >> /bin/startdb && \	
    echo 'service oracle-xe start' >> /bin/startdb && \
    echo 'echo "alter system disable restricted session;" | sqlplus -s SYSTEM/oracle' >> /bin/startdb && \
    echo 'echo "EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);" | sqlplus -s SYSTEM/oracle' >> /bin/startdb && \
    echo '/usr/sbin/sshd -D &' >> /bin/startdb && \
    chmod +x /bin/startdb	

EXPOSE 1521 22 8080

CMD startdb && tail -f /usr/lib/oracle/xe/app/oracle/admin/XE/bdump/alert_XE.log
