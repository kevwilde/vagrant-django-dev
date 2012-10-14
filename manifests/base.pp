

node default {

	$projectname 		= 'mydjango'	

	$db_name 			= 'mydjangodb'
	$db_user 			= 'dbuser'
	$db_password 		= 'dbpassword'
	


	# PYTHON

	Exec {
  		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	}

	# -- enable dev packages

	class {'python::dev': 
		version => '2.7',
	}

	class { "python::venv": 
		owner => "vagrant", 
		group => "vagrant",
	}

	# -- create venv

	python::venv::isolate { "/home/vagrant/venv/${projectname}":
		version => '2.7',
		# requirements => "/var/www/${projectname}/requirements.txt",
	}

	# -- automatic activation of venv

	include bash



	# POSTGRES

	# -- setup client

	class {'postgresql':
        version => '9.1',
    }

    # -- setup server

    class { 'postgresql::server':
        locale => 'en_US.UTF-8',
        version => '9.1',
		listen => ['*', ],
		port   => 5432,
		acl   => ['host all all 10.0.0.0/24 md5', ],
    }

    # -- add database

    postgresql::db { $db_name:
        owner    => $db_user,
        password => $db_password
    }

}