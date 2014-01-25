# update apt-get
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

# pretty common build tools
package {'openjdk-7-jdk':
  ensure => installed,
}

package {'curl':
  ensure => installed,
}
package { 'git':
  ensure  => installed,
}
package { 'man':
  ensure => installed,
}
package { 'tree':
  ensure => installed,
}
package { 'vim':
  ensure => installed,
}
#package { 'protobuf-compiler':
#  ensure => installed,
#}

define wwwTarInstall ($installedName = $title, $url, $basePath, $linkName, $tarFileName) {
  exec {"/tmp/vagrant-cache/www/$tarFileName":
	command => "curl -o /tmp/vagrant-cache/www/$tarFileName $url",
	unless => "[ -f /tmp/vagrant-cache/www/$tarFileName ]",
	provider => 'shell',
        require  => Package['curl'],
  }
  exec {"$basePath/$installedName":
	command => "tar --no-same-owner -C $basePath -zxf  /tmp/vagrant-cache/www/$tarFileName",
	unless  => "[ -d $basePath/$installedName ]",
	provider => 'shell',
	require  => Exec["/tmp/vagrant-cache/www/$tarFileName"],
  }
  file { "$basePath/$linkName":
  	ensure => 'link',
  	target => "$basePath/$installedName",
  	require => Exec["$basePath/$installedName"],
  }
  file { "/etc/profile.d/$linkName.sh":
         ensure => present,
         content => "export PATH=\$PATH:$basePath/$linkName/bin",
         require => File["$basePath/$linkName"],
  }
}

wwwTarInstall {'apache-maven-3.1.1':
  url         => 'http://apache.spinellicreations.com/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz',
  basePath    => '/opt',
  tarFileName => 'apache-maven-3.1.1-bin.tar.gz',
  linkName    => 'maven',
}
wwwTarInstall {'zookeeper-3.4.5':
  url         => 'http://download.nextag.com/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz',
  basePath    => '/opt',
  tarFileName => 'zookeeper-3.4.5.tar.gz',
  linkName    => 'zookeeper',
}
wwwTarInstall {'hadoop-2.2.0':
  url         => 'http://apache.spinellicreations.com/hadoop/common/hadoop-2.2.0/hadoop-2.2.0.tar.gz',
  basePath    => '/opt',
  tarFileName => 'hadoop-2.2.0.tar.gz',
  linkName    => 'hadoop',
}
wwwTarInstall {'hbase-0.96.1.1-hadoop2':
  url         => 'http://mirror.nexcess.net/apache/hbase/hbase-0.96.1.1/hbase-0.96.1.1-hadoop2-bin.tar.gz',
  basePath    => '/opt',
  tarFileName => 'hbase-0.96.1.1-hadoop2-bin.tar.gz',
  linkName    => 'hbase',
}
wwwTarInstall {'accumulo-1.7.0-SNAPSHOT':
  url         => 'http://tasermonkeys.com/accumulo-1.7.0-SNAPSHOT-bin.tar.gz',
  basePath    => '/opt',
  tarFileName => 'accumulo-1.7.0-SNAPSHOT-bin.tar.gz',
  linkName    => 'accumulo',
}
wwwTarInstall {'protobuf-2.5.0':
  url         => 'http://tasermonkeys.com/protobuf-2.5.0-vagrant-precise64-bin.tar.gz',
  basePath    => '/opt',
  tarFileName => 'protobuf-2.5.0-vagrant-precise64-bin.tar.gz',
  linkName    => 'protobuf',
}

file {'/opt/zookeeper/conf/zoo.cfg':
  ensure   => present,
  source   => '/opt/zookeeper/conf/zoo_sample.cfg',
  require  => WwwTarInstall['zookeeper-3.4.5'],
}

#exec { 'maven':
#      	command  => 'curl http://apache.spinellicreations.com/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz | tar -C /opt -zx',
#      	unless   => '[ -d /opt/apache-maven-3.1.1 ]',
#      	provider => 'shell',
#        require  => Package['curl'],
#}
#exec { 'zookeeper':
#      	command  => 'curl http://download.nextag.com/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz | tar -C /opt -zx',
#      	unless   => '[ -d /opt/zookeeper-3.4.5 ]',
#      	provider => 'shell',
#        require  => Package['curl'],
#}
#exec { 'hadoop':
#      	command  => 'curl http://apache.spinellicreations.com/hadoop/common/hadoop-2.2.0/hadoop-2.2.0.tar.gz | tar -C /opt -zx',
#      	unless   => '[ -d /opt/hadoop-2.2.0 ]',
#      	provider => 'shell',
#        require  => Package['curl'],
#}
#exec { 'hbase':
#      	command  => 'curl http://mirror.nexcess.net/apache/hbase/hbase-0.96.1.1/hbase-0.96.1.1-hadoop2-bin.tar.gz | tar -C /opt -zx',
#      	unless   => '[ -d /opt/hbase-0.96.1.1-hadoop2 ]',
#      	provider => 'shell',
#        require  => Package['curl'],
#}
#
#exec { 'accumulo':
#      	command  => 'curl http://tasermonkeys.com/accumulo-1.7.0-SNAPSHOT-bin.tar.gz | tar -C /opt -zx',
#      	unless   => '[ -d /opt/accumulo-1.7.0-SNAPSHOT ]',
#      	provider => 'shell',
#        require  => Package['curl'],
#}

#file { '/opt/zookeeper':
#	ensure => 'link',
#	target => '/opt/zookeeper-3.4.5',
#	require => Exec['zookeeper'],
#}
#
#file { '/opt/hadoop':
#	ensure => 'link',
#	target => '/opt/hadoop-2.2.0',
#	require => Exec['hadoop'],
#}
#
#file { '/opt/hbase':
#	ensure => 'link',
#	target => '/opt/hbase-0.96.1.1-hadoop2',
#	require => Exec['hbase'],
#}
#
#file { '/opt/accumulo':
#	ensure => 'link',
#	target => '/opt/accumulo-1.7.0-SNAPSHOT',
#	require => Exec['accumulo'],
#}
#
#file { '/opt/maven':
#	ensure => 'link',
#	target => '/opt/apache-maven-3.1.1',
#	require => Exec['maven'],
#}
#
#file { '/etc/profile.d/mvn.sh':
#       ensure => present,
#       content => 'export PATH=$PATH:/opt/maven/bin',
#       require => File['/opt/maven'],
#}
#file { '/etc/profile.d/hadoop.sh':
#       ensure => present,
#       content => 'export PATH=$PATH:/opt/hadoop/bin',
#       require => File['/opt/hadoop'],
#}
#file { '/etc/profile.d/hbase.sh':
#       ensure => present,
#       content => 'export PATH=$PATH:/opt/hbase/bin',
#       require => File['/opt/hbase'],
#}
#file { '/etc/profile.d/zookeeper.sh':
#       ensure => present,
#       content => 'export PATH=$PATH:/opt/zookeeper/bin',
#       require => File['/opt/zookeeper'],
#}
#file { '/etc/profile.d/accumulo.sh':
#       ensure => present,
#       content => 'export PATH=$PATH:/opt/accumulo/bin',
#       require => File['/opt/accumulo'],
#}

# For thrift compiler build
package { 'python-minimal':
  ensure => installed,
}
# For clojure development
exec { 'lein':
      	command  => 'mkdir -p /usr/local/bin && wget -O /usr/local/bin/lein https://raw.github.com/technomancy/leiningen/stable/bin/lein && chmod oug+rx /usr/local/bin/lein',
      	unless   => '[ -f /usr/local/bin/lein ]',
      	provider => 'shell',
}








##### RBEnv installation
#class { 'rbenv': }
#rbenv::plugin { 'sstephenson/ruby-build': }
#rbenv::build { '1.9.3-p484': global => true }
