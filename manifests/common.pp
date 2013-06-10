# Deploy the KermIT common files
# used by the KermIT dashboard
# Cf http://www.kermit.fr

class kermit::common {

    file { '/etc/kermit/' :
        ensure  => directory,
    }

}

