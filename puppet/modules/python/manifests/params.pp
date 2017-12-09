class python::params {

  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon': {
      $package = 'python'
      $development_packages = ['python-devel']
    }
    'Debian', 'Ubuntu': {
      $package = 'python'
      $development_packages = ['python-dev', 'python-pip']
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }
}
