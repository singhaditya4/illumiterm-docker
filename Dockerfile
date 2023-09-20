# Ubuntu build environment for IllumiTerm
# sudo docker build -t jimni --no-cache=true .
# docker run -it --rm jimni bash -c "bash"
FROM accetto/ubuntu-vnc-xfce:latest
RUN /bin/bash -c 'apt update -y && apt upgrade -y '
COPY dotfiles/.bashrc /root/.bashrc
RUN /bin/bash -c 'source $HOME/.bashrc && \
apt install neofetch -y '
RUN /bin/bash -c 'apt install make libtool sudo libgtk-3-dev libvte-2.91-dev -y'

#RUN /bin/bash -c 'useradd -m admin'
#RUN /bin/bash -c 'echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
RUN /bin/bash -c 'echo "root:password" | chpasswd'
RUN /bin/bash -c 'git clone https://github.com/IllumiTerm/illumiterm && \
cd illumiterm && \
chmod +x ./autogen.sh && bash ./autogen.sh && \
bash ./configure && \
make && \
make install'

# start package compilation