FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# create the directory for the socket
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld  

COPY tools/start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 3306

CMD ["./start.sh"]
