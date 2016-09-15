class backup(
	$secret_host,
	$ca = "/etc/ssl/certs/host-ca.crt",
	$cert = "/etc/ssl/certs/host.crt",
	$key = "/etc/ssl/private/host.key",
) {

	package { "duply":
		ensure => installed,
	}
	
	$host = $trusted['certname']

	file { "/etc/duply":
		ensure => directory,
		require => Package["duply"],
	}

	file { "/etc/duply/default":
		ensure => directory,
		require => File["/etc/duply"],
	}

	file { "/etc/duply/default/pre.d":
		ensure => directory,
		require => File["/etc/duply/default"],
	}
	
	file { "/etc/duply/default/post.d":
		ensure => directory,
		require => File["/etc/duply/default"],
	}

	if (!defined(Package["wget"])) {
		package{ "wget":
			ensure => installed,
		}
	}

	$substituted_host = regsubst($host, '\.', '_', 'G')
	exec { "download persistent gpg key":
		creates => "/etc/duply/default/gpgkey.$substituted_host.asc",
		require => [
			File["/etc/duply/default"],
			File[$ca],
			File[$cert],
			File[$key],
			Package["wget"],
		],
		command => "/usr/bin/wget --ca-certificate=\"$ca\" --certificate=\"$cert\" --private-key=\"$key\" https://$secret_host/gpg --output-document=/etc/duply/default/gpgkey.$substituted_host.asc",
	}

	file { "/etc/duply/default/conf":
		ensure => file,
		content => epp("backup/conf.epp", {"host" => $host}),
		require => File["/etc/duply/default"],
	}
}
