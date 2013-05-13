class ant {
	exec { "remove_ant" :
		command => "rm -rf /home/${bahmni_user}/apache-ant*",
		path 		=> "${os_path}",
		user 		=> "${bahmni_user}"
	}

	exec { "ant_untar" :
	  command => "tar zxf ${package_dir}/tools/apache-ant*.tar.gz ${deployment_log_expression}",
	  user    => "${bahmni_user}",
	  cwd     => "/home/${bahmni_user}",
	  creates => "${ant_home}",
	  path    => "${os_path}",
	  require => Exec["remove_ant"]
	}
}