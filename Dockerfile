FROM registry.krim.dev/kasm/kasm-krimbase-xfce:latest
WORKDIR /tmp/
USER root
RUN echo "kasm-user  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt update && apt upgrade -y
RUN apt install -y openjdk-18-jre
COPY --chmod=777 ./JDownloader.jar /opt/
COPY --chmod=777 ./run.sh /opt/

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
COPY ./run.desktop /etc/xdg/autostart/run.desktop
RUN apt-get remove -y xfce4-panel

USER 1000