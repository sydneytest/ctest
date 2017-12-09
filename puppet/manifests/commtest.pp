node "instance-2.c.kubeproject-187423.internal" {
 include python
 include pip

 pip::install { 'virtualenv':
  package        => 'virtualenv', 
  ensure         => present,  
}

}
