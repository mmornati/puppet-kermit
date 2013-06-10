# Install and set a simple REST server that you can use to communicate with
# MCollective (rpc communication).
# Used with KermIT
# See
# https://puppetlabs.com/mcollective/introduction/
# http://www.kermit.fr

class kermit::rest {
    include yum
    include kermit::yum
    include kermit::common
    include passenger

    include mcollective::client

    package { 'kermit-restmco' :
        ensure  => present,
        require => [ Yumrepo['kermit-custom', 'kermit-thirdpart'], ],
    }

    service { 'kermit-restmco' :
        ensure => stopped,
        enable => false,
    }

    file { '/etc/kermit/kermit-restmco.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/rest/kermit-restmco.cfg',
        require => File[ '/etc/kermit' ],
        notify  => Service [ 'httpd' ],
    }

    file { '/var/log/kermit-restmco.log' :
        ensure => present,
        owner  => 'nobody',
        group  => 'nobody',
        mode   => '0640',
    }

    file { '/var/www/restmco' :
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/var/www/restmco/tmp' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File[ '/var/www/restmco' ],
    }

    file { '/var/www/restmco/public' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File[ '/var/www/restmco' ],
    }

    file { '/var/www/restmco/tmp/restart.txt' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File[ '/var/www/restmco/tmp' ],
    }

    file { 'mc-rpc-restserver.rb' :
        ensure  => present,
        path    => '/var/www/restmco/mc-rpc-restserver.rb',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/rest/mc-rpc-restserver.rb',
        require => File[ '/var/www/restmco' ],
        notify  => Service [ 'httpd' ],
    }

    file { 'config.ru' :
        ensure  => present,
        path    => '/var/www/restmco/config.ru',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/rest/config.ru',
        require => File[ '/var/www/restmco' ],
        notify  => Service [ 'httpd' ],
    }

    file { 'restmco.conf' :
        ensure  => present,
        path    => '/etc/httpd/conf.d/restmco.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermit/rest/restmco.conf',
        require => Package[ 'httpd' ],
        notify  => Service [ 'httpd' ],
    }

}
