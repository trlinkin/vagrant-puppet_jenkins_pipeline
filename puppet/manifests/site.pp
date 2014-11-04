node default{

  # Lets get some Jenkins going up in here!
  include ::jenkins

  # Manage our luxurious suite of Jenkins Modules
  ############################################################################

  # Install dependency plugins, that is to say, plugins that are probably cool
  # on their own, but are really only here to support the primary plugins in
  # this example.
  jenkins::plugin { 'credentials': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'ruby-runtime': }
  jenkins::plugin { 'jquery': }
  jenkins::plugin { 'jquery-ui': }
  jenkins::plugin { 'token-macro': }

  # Primary Plugins
  jenkins::plugin { 'git': }
  jenkins::plugin { 'ws-cleanup': }
  jenkins::plugin { 'delivery-pipeline-plugin': }
  jenkins::plugin { 'copyartifact': }
  jenkins::plugin { 'greenballs': }
  jenkins::plugin { 'chucknorris': }
  jenkins::plugin { 'build-flow-plugin': }
  jenkins::plugin { 'dynamic-axis': }

  # Other Dependencies utilized in our Jenkins plugins and/or our build steps
  ############################################################################

  include ::git

  # We will be using RVM to manage our rubies for multiple builds, however
  # since this is a simple pipeline example, we're only going to install one
  # ruby for the time being. Version 1.9.3-p484 is the current version
  # packaged with Puppet Enterprise 3.3.x.
  class { '::rvm':
    version => '1.25.33',
  }
  rvm::system_user {'jenkins':}
  rvm_system_ruby { '1.9.3-p484', '2.1.1':
    ensure => 'present',
  }


  ##### And now for some janky magic! (shhhhhh, it's ok)
  ############################################################################

  # Durring this example, the nokogiri gem is attempted to be built from
  # source. This will require libxslt-devel and libxml-devel to be installed.
  package { ['libxslt-devel', 'libxml2-devel']:
    ensure => installed,
  }

  # SIDE NOTE: Cache your gems!
  # Durring this example, we will be downloading gems directly from the Internet.
  # In a real environment, it would recommened to provide an internal gem
  # mirror to point builds at. This is helpful since it may speed up the builds
  # and make it resilient against failures of availability on the Internet.


  # Place the example job configurations in place
  file { 'jenkins_jobs':
    ensure  => directory,
    path    => '/var/lib/jenkins/jobs',
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => '/vagrant/jenkins-configs/jobs',
    recurse => remote,
    notify  => Exec['reload jenkins jobs'],
  }

  # Place an example root config
  file { 'jenkins_config':
    ensure => file,
    path   => '/var/lib/jenkins/config.xml',
    owner  => 'jenkins',
    group  => 'jenkins',
    source => '/vagrant/jenkins-configs/config.xml',
    notify => Exec['reload jenkins jobs'],
  }

  Jenkins::Plugin<||> -> File['jenkins_config', 'jenkins_jobs']

  # Tell Jenkins to reload configuratios without restarting
  exec { 'reload jenkins jobs':
    command     => '/usr/bin/curl --retry-max-time 30 --retry 3 --retry-delay 5 -d "Submit=Yes" http://localhost:8080/reload',
    tries       => '3',
    try_sleep   => '5',
    refreshonly => true,
  }


  # F*ck it, Ship it
  service { 'iptables':
    ensure => stopped,
  }
}
