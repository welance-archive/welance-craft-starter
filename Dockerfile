FROM node:6-alpine

RUN apk add --no-cache bash
RUN mkdir -p /data/app
WORKDIR /data/app  
VOLUME /data/app

COPY ./scripts/node/entrypoint.sh /data/entrypoint.sh  
ENTRYPOINT [ "/data/entrypoint.sh" ]

CMD [ "npm", "start" ]

EXPOSE 80