FROM archlinux:latest
 
ENV container=docker  
 
COPY container.target /etc/systemd/system/container.target
 
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target
 
RUN pacman -Sy --noconfirm systemd

CMD ["--log-level=info"]
STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/usr/lib/systemd/systemd"]


