#Backup
This configures backups using duplicity and [SecretServer](https://github.com/thexa4/secrets-server).

Uses [PKI module](https://forge.puppet.com/thexa4/pki) to automatically setup client certificates.

##Usage
Available parameters:

* `$secret_host`
* `$backup_destination`
* `$ca = "/etc/ssl/certs/host-ca.crt"`
* `$cert = "/etc/ssl/certs/host.crt"`
* `$key = "/etc/ssl/private/host.key"`
* `$excludes = ['/proc','/sys','/dev','/proc','/run','/media','/mnt','/pub','**/.cache']`

##Custom configuration
Almost all configuration can be changed by placing files in the following folders

* `/etc/duply/default/conf.d/`: Allows overriding duply config settings (run `duply template create` for an overview of available settings)
* `/etc/duply/default/pre.d/`: Allows running scripts before a backup (for database snapshotting for example)
* `/etc/duply/default/post.d/`: Allows running scripts after a backup

##See also
Works with [backup_hubic](https://forge.puppet.com/thexa4/backup_hubic) if you need Hubic as a target
