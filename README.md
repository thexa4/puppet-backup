#Backup
This configures backups using duplicity and [SecretServer](https://github.com/thexa4/secrets-server).

Uses [PKI module](https://github.com/thexa4/puppet-pki) to automatically setup client certificates.

##Usage
Available parameters:

* `$secret_host`
* `$ca = "/etc/ssl/certs/host-ca.crt"`
* `$cert = "/etc/ssl/certs/host.crt"`
* `$key = "/etc/ssl/private/host.key"`

