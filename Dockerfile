FROM registry.krim.dev/kasm/kasm-krimbase-xfce:latest
WORKDIR /tmp/
USER root
RUN echo "kasm-user  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list && \
    echo 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | sudo tee /etc/apt/preferences.d/mozilla

RUN apt update && apt upgrade -y
RUN apt install -y openjdk-18-jre
RUN chmod -R 777 /opt/
RUN apt-get remove -y xfce4-panel && apt-get autoremove -y

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ttf-mscorefonts-installer firefox && fc-cache -f -v

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
RUN java -jar -Djava.awt.headless=true /opt/JDownloader/JDownloader.jar


