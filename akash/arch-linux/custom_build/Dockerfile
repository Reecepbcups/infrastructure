FROM archlinux:latest
 
ENV container=docker  
 
COPY container.target /etc/systemd/system/container.target
 
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target
 
ENTRYPOINT ["/sbin/init"]
CMD ["--log-level=info"]

# mount to the host /sys/fs/cgroup
ADD . /sys/fs/cgroup
ADD . /sys/fs/fuse
# ADD tmpfs /run/lock

 
STOPSIGNAL SIGRTMIN+3
