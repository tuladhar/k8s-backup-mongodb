FROM mongo:latest

RUN apt update && \
    apt install awscli -y

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI="" \
    MONGODB_OPLOG="" \
    BUCKET_URI="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY "" \
    AWS_DEFAULT_REGION ""

CMD ["/scripts/backup-mongodb.sh"]
