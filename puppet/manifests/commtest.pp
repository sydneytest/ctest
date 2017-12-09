node default {
 include python
 include pip

 pip::install { 'virtualenv':
  package        => 'virtualenv', 
  ensure         => present,  
 }
}
