FROM gitpod/workspace-full

ARG YB_VERSION=2.8.0.0
ARG YB_PATH=/usr/local/yugabyte
ARG ROLE=gitpod

USER root
RUN mkdir -p $YB_PATH \
  && mkdir -p /var/ybdp
RUN chown -R $ROLE:$ROLE /var/ybdp \
  && chown -R $ROLE:$ROLE /usr/local/yugabyte

USER $ROLE
RUN curl -sSLo ./yugabyte.tar.gz https://downloads.yugabyte.com/yugabyte-${YB_VERSION}-linux.tar.gz \
  && tar -xvf yugabyte.tar.gz -C $YB_PATH --strip-components=1 \
  && chmod +x $YB_PATH/bin/* \
  && rm ./yugabyte.tar.gz
RUN ["/usr/local/yugabyte/bin/post_install.sh"]
RUN echo "\n# yugabytedb executable path" >> ~/.bashrc
RUN echo "export PATH=\$PATH:$YB_PATH/bin/" >> ~/.bashrc

ENV HOST=127.0.0.1
ENV STORE=/var/ybdp
ENV YSQL_PORT=5433
ENV YCQL_PORT=9042
ENV WEB_PORT=7000
ENV TSERVER_WEB_PORT=9000
ENV YSQL_API_PORT=13000
ENV YCQL_API_PORT=12000

# re-initialization is automatically handled 
RUN echo "\n# yugabytedb start command" >> ~/.bashrc
RUN echo "yugabyted start --base_dir=$STORE --listen=$HOST" >> ~/.bashrc

EXPOSE ${YSQL_PORT} ${YCQL_PORT} ${WEB_PORT} ${TSERVER_WEB_PORT} ${YSQL_API_PORT} ${YCQL_API_PORT}
