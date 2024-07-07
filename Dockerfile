FROM registry.krim.dev/library/kasm-krimbase-xfce:latest
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
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN apt-get remove -y xfce4-panel

USER 1000