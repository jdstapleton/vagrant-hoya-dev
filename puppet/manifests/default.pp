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
#The version of protobuf in the yum repo is too old.  
#package { 'protobuf-compiler':
#  ensure => installed,
#}

file { "/tmp/vagrant-cache":
  owner   => "vagrant",
  group   => "vagrant",
  ensure  => "directory",
  mode    => 755,
}

file { "/tmp/vagrant-cache/www":
  owner   => "vagrant",
  group   => "vagrant",
  ensure  => "directory",
  mode    => 755,
  require => File["/tmp/vagrant-cache"]
}


define wwwTarInstall ($installedName = $title, $url, $basePath, $linkName, $tarFileName) {
  exec {"/tmp/vagrant-cache/www/$tarFileName":
	command => "curl -o /tmp/vagrant-cache/www/$tarFileName $url",
	unless => "[ -f /tmp/vagrant-cache/www/$tarFileName ]",
	provider => 'shell',
        require  => [Package['curl'],File["/tmp/vagrant-cache/www"]],
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
#####
##  The version of protobuf in the yum repo is too old.  This is a precompiled binary that 
##  I compiled just for this VM (vagrant base image for precise64).  Its a statically linked
##  binary to make it easy to distribute.
#####
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
