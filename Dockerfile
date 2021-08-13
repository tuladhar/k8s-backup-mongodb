FROM mongo:5.0

RUN apt update
RUN apt install awscli -y

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI ""
ENV MONGODB_OPLOG ""
ENV BUCKET_URI ""
ENV AWS_DEFAULT_REGION ""

CMD ["/scripts/backup-mongodb.sh"]
