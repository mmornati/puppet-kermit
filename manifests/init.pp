# Deploy the KermIT backend
# Custom agents and queues for MCollective
# used by the KermIT dashboard
# Cf http://www.kermit.fr

class kermit( $recvnode = 'el6', $nocnode = 'el6' ) {

    include mcollective
    include yum::kermit

    file { '/etc/kermit/' :
        ensure  => directory,
    }

    file { '/etc/kermit/ssl/' :
        ensure  => directory,
        require => File[ '/etc/kermit/' ],
    }

    file { '/etc/kermit/ssl/q-private.pem' :
        ensure  => $::hostname ? {
            $recvnode => absent,
            default   => present,
        },
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///public/kermit/q-private.pem', # yes, it is public
        require => [ File['/etc/kermit/ssl/'], Package['mcollective-common'] ],
    }

    file { '/etc/kermit/kermit.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/kermit.cfg',
        require => File['/etc/kermit/'],
    }

    file { '/etc/kermit/amqpqueue.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/amqpqueue.cfg',
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
        source  => 'puppet:///modules/kermit/send.rb',
        require => File['/usr/local/bin/kermit/queue/'],
    }

    file { '/usr/local/bin/kermit/queue/sendlog.rb' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/sendlog.rb',
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

    $mcoplug_packages = [ 'mcollective-plugins-agentinfo',
      'mcollective-plugins-nodeinfo', 'mcollective-plugins-facter_facts',
      'mcollective-plugins-package',  'mcollective-plugins-service' ]

    package { $mcoplug_packages :
        ensure  => installed,
        require => [  Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
                      Package[ 'mcollective-common' ], ],
    }

    $agentsrc = $::hostname ? {
        $nocnode => undef,
        default  => 'puppet:///modules/mcoagents',
    }

    file { '/usr/libexec/mcollective/mcollective/agent' :
          ensure  => directory,
          recurse => true,   # <- That's all needed --v
          source  => $agentsrc,
          owner   => 'root',
          group   => 'root',
          require => Package[ 'mcollective-common' ],
          notify  => Service[ 'mcollective' ],
    }

    package { 'mcollective-puppet-agent' :
        ensure  => present,
        require => [  Yumrepo[ 'kermit-thirdpart' ],
                      Package[ 'mcollective-common' ], ],
    }

    package { 'mcollective-puppet-client' :
        ensure  => $::hostname ? {
            $nocnode => present,
            default  => absent,
        },
        require => [  Yumrepo[ 'kermit-thirdpart' ],
                      Package[ 'mcollective-common' ], ],
    }

}

