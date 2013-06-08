# Deploy the custom agents for MCollective
# used by the KermIT dashboard
# Cf http://www.kermit.fr

class kermit::mcoagents {

    include mcollective

    $mcoplug_packages = [
#      'mcollective-plugins-agentinfo',
#      'mcollective-plugins-nodeinfo',
      'mcollective-plugins-facter_facts',
      'mcollective-plugins-package',
      'mcollective-plugins-service'
    ]

    package { $mcoplug_packages :
        ensure  => installed,
        require => [  Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
                      Package[ 'mcollective-common' ], ],
    }

    file { '/usr/libexec/mcollective/mcollective/agent' :
          ensure  => directory,
          recurse => true,   # <- That's all needed --v
          source  => 'puppet:///modules/kermit/mcoagents',
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

}

