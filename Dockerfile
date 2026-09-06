FROM itzg/minecraft-server

COPY plugins/WorldReset-1.7.jar /plugins/WorldReset-1.7.jar
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
