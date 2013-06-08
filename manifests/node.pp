# Deploy the KermIT backend and queues for MCollective
# used by the KermIT dashboard
# Cf http://www.kermit.fr

class kermit::node( $recvnode = 'el6.labothink.fr' ) {

    include mcollective
    include kermit::yum
    include kermit::mcoagents

    file { '/etc/kermit/' :
        ensure  => directory,
    }

    file { '/etc/kermit/ssl/' :
        ensure  => directory,
        require => File[ '/etc/kermit/' ],
    }

    file { '/etc/kermit/ssl/q-private.pem' :
        ensure  => $::fqdn ? {
            $recvnode => absent,
            default   => present,
        },
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///public/kermit/node/q-private.pem', # yes, it is public
        require => [ File['/etc/kermit/ssl/'], Package['mcollective-common'] ],
    }

    file { '/etc/kermit/kermit.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/node/kermit.cfg',
        require => File['/etc/kermit/'],
    }

    file { '/etc/kermit/amqpqueue.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/node/amqpqueue.cfg',
        require => File['/etc/kermit/'],
    }

    file { '/usr/local/bin/kermit' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/usr/local/bin/kermit/queue' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File['/usr/local/bin/kermit'],
    }

    file { '/usr/local/bin/kermit/queue/send.rb' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/node/send.rb',
        require => File['/usr/local/bin/kermit/queue/'],
    }

    file { '/usr/local/bin/kermit/queue/sendlog.rb' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/node/sendlog.rb',
        require => File['/usr/local/bin/kermit/queue/'],
    }

    $mcoreq_packages = [ 'kermit-gpg_key_whs', 'kermit-mqsend',
        'rubygem-curb', 'rubygem-inifile', 'rubygem-json',
        'rubygem-xml-simple', 'rubygem-ruby-rpm', 'rubygem-rubyzip',
        'rubygem-sys-filesystem', ]

    package { $mcoreq_packages :
        ensure  => present,
        require => Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
    }

}

