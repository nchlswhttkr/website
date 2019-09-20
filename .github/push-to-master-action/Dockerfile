FROM ubuntu:18.04

RUN apt update -qqy && apt install -qqy git

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
