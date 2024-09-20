FROM registry.krim.dev/kasm/kasm-krimbase-xfce:latest
WORKDIR /tmp/
USER root
RUN echo "kasm-user  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt update && apt upgrade -y
RUN apt install -y openjdk-18-jre
RUN chmod -R 777 /opt/
RUN apt-get remove -y xfce4-panel

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
RUN mkdir -p /opt/JDownloader/
RUN mkdir -p /home/kasm-user/jd/
COPY --chmod=777 ./JDownloader.jar /opt/JDownloader/
COPY --chmod=777 ./run.sh /opt/
RUN ln -s /home/kasm-user/jd/ /opt/JDownloader/cfg


COPY ./run.desktop /etc/xdg/autostart/run.desktop
RUN timeout 30s java -jar -Djava.awt.headless=true /opt/JDownloader/JDownloader.jar


