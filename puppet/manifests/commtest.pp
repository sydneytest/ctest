node default {
  include python
  include pip

  pip::install { 'virtualenv':
    package        => 'virtualenv',
    ensure         => present,
  } ->

  file { '/opt/app':
    ensure => 'directory',
  } ->

  exec { 'untar':
    command     => '/bin/tar -zxf /tmp/flask/packages/system-engineer.tar.gz -C /opt/app/',
  } ->

  exec { 'appdir':
    cwd => '/opt/app/system-engineer',
    command => '/bin/virtualenv .',
  } ->

  exec { 'installpackages':
    cwd => '/opt/app/system-engineer',
    command => '/bin/pip install -r requirements.txt',
  } ->

  exec { 'deployapp':
    cwd => '/opt/app/system-engineer',
    command => '/bin/nohup /bin/python app/app.py &',
  }
    

}
