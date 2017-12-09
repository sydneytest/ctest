# == Class: python
#
# Installs Python and associated development packages
#
# === Examples
#
# include python
#
class python {

  include python::params

  package {
    $python::params::package:
      ensure => installed,
  }

  package {
    $python::params::development_packages:
      ensure => installed,
  }
}
