# Set a daemon listening to a queue were the KermIT nodes push some information
# like inventories and logs

class kermit::qrecv {

    #include yum
    include kermit::yum
    include kermit::node

    package { 'kermit-mqrecv' :
        ensure   => present,
        require  => Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
    }

    file { '/etc/kermit/ssl/q-public.pem' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///private/kermitqrecv/q-public.pem',
        require => File[ '/etc/kermit/ssl/' ],
    }

    file { '/var/lib/kermit' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/var/lib/kermit/queue' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit'] ],
    }

    file { 'kermit_inventory' :
        ensure  => directory,
        path    => '/var/lib/kermit/queue/kermit.inventory',
        owner   => 'nobody',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit/queue'] ],
    }

    file { 'kermit_log' :
        ensure  => directory,
        path    => '/var/lib/kermit/queue/kermit.log',
        owner   => 'nobody',
        group   => 'root',
        mode    => '0755',
        require => [ File['/var/lib/kermit/queue'] ],
    }

    service { 'kermit-inventory' :
        ensure  => running,
        enable  => true,
        require => [ Package['kermit-mqrecv'], File['kermit_inventory'], ],
    }

    service { 'kermit-log' :
        ensure  => running,
        enable  => true,
        require => [ Package['kermit-mqrecv'], File['kermit_log'], ],
    }
}
