# Arch on Akash


> Create a new Deployment with Cloudmos on Akash
> Modify the deploy.yaml to your needs
> Get the URL & PORT which was forwarded, use those to SSH in.

ssh root@5uo6vs083l803f6bndtdd45bg0.ingress.example.com -p 31573

For best security, you should:
```
- ssh-copy-id root@akash_host -p PORT
- disable PermitRootLogin in /etc/ssh/sshd_config
- create a user with their own home directory.
```