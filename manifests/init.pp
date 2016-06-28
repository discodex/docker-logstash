# == Class: docker-gen
#
# Installs the docker-gen application and ensures it is running
#
# === Parameters
# 
# 
# 
class docker-gen(
    $docker_env		= undef,
    $logstash_server	= undef
){
    case $::operatingsystemmajrelease {
        '7':{
                $base_dir = '/opt/docker-gen'
                $template_dir = '/etc/docker-gen'
                $unit_dir = '/usr/lib/systemd/system'
	        $docker_gen_pkg = 'docker-gen'
            }
            default: { fail ( "This module does not support $::operatingsystemmajrelease family of Operating Systems") }
	    }
    file { "$base_dir":
	ensure => directory,
	mode   => 755,
        owner  => 'root',
        group  => 'root',
	}
    file { "$template_dir":
        ensure => directory,
        mode   => 755,
        owner  => 'root',
        group  => 'root',
        }
    file { "$base_dir/docker-gen":
        ensure => present,
        mode   => 755,
        owner  => 'systuser',
        group  => 'systuser',
        source => "puppet:///modules/docker-gen/docker-gen",
	}
    file {"$template_dir/logstash-forwarder.tmpl":
        ensure => present,
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
        content => template("docker-gen/logstash-forwarder.erb"),
	}
    file {"$unit_dir/docker-gen.service":
        ensure => present,
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
        source => "puppet:///modules/docker-gen/docker-gen.service",
    }
    service {'docker-gen':
	ensure    => running,
	enable    => true,
	subscribe => File["$template_dir/logstash-forwarder.tmpl"],
    }
}

