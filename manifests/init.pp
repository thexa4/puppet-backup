class backup(
  $secret_host,
  $backup_destination,
  $ca = '/etc/ssl/certs/host-ca.crt',
  $cert = '/etc/ssl/certs/host.crt',
  $key = '/etc/ssl/private/host.key',
) {

  package { 'duply':
    ensure => installed,
  }
  
  $host = $::trusted['certname']

  file { '/etc/duply':
    ensure  => directory,
    mode    => '0700',
    require => Package['duply'],
  }

  file { '/etc/duply/default':
    ensure  => directory,
    require => File['/etc/duply'],
  }

  file { '/etc/duply/default/pre.d':
    ensure  => directory,
    require => File['/etc/duply/default'],
  }
  
  file { '/etc/duply/default/post.d':
    ensure  => directory,
    require => File['/etc/duply/default'],
  }

  if (!defined(Package['wget'])) {
    package{ 'wget':
      ensure => installed,
    }
  }

  $substituted_host = regsubst($host, '\.', '_', 'G')
  exec { 'download persistent gpg key':
    creates => "/etc/duply/default/gpgkey.${substituted_host}.asc",
    require => [
      File['/etc/duply/default'],
      File[$ca],
      File[$cert],
      File[$key],
      File['/etc/duply/default/conf'],
      File['/etc/duply/default/pre.d'],
      File['/etc/duply/default/pre'],
      File['/etc/duply/default/post.d'],
      File['/etc/duply/default/post'],
      Package['wget'],
    ],
    command => "/usr/bin/wget --ca-certificate=\"${ca}\" --certificate=\"${cert}\" --private-key=\"${key}\" https://${secret_host}/gpg --output-document=/etc/duply/default/gpgkey.${substituted_host}.asc && (/usr/bin/duply default status || true)",
    #logoutput => true,
  }

  file { '/etc/duply/default/conf':
    ensure  => file,
    content => epp('backup/conf.epp', {
      'host'               => $host,
      'backup_destination' => $backup_destination,
      }),
    require => File['/etc/duply/default'],
  }

  file { '/etc/duply/default/pre':
    ensure  => file,
    content => "#!/bin/bash\n# Managed by puppet\nDIR=\"\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd )\"\nrun-parts \"\$DIR/pre.d\"\n",
    require => File['/etc/duply/default'],
  }
  
  file { '/etc/duply/default/post':
    ensure  => file,
    content => "#!/bin/bash\n# Managed by puppet\nDIR=\"\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd )\"\nrun-parts \"\$DIR/post.d\"\n",
    require => File['/etc/duply/default'],
  }
}
