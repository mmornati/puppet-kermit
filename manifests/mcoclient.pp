# Deploy the custom client for MCollective
# used by the KermIT dashboard
# Cf http://www.kermit.fr

class kermit::mcoclient {

    include mcollective

    package { 'mcollective-puppet-client' :
        ensure  => present,
        require => [  Yumrepo[ 'kermit-thirdpart' ],
                      Package[ 'mcollective-common' ], ],
    }

}

