  class implementation_config::openmrs {
  $openmrs_dir = "/home/${bahmni_user}/.OpenMRS"
  $beanshell_dir = "${build_output_dir}/${implementation_name}_config/openmrs/beanshell"
  $obscalculator_dir = "${build_output_dir}/${implementation_name}_config/openmrs/obscalculator"
  $patient_matching_algorithm_dir = "${build_output_dir}/${implementation_name}_config/openmrs/patientMatchingAlgorithm"
  $ordertemplates_dir = "${build_output_dir}/${implementation_name}_config/openmrs/ordertemplates"
  $encounter_modifier_scripts_dir = "${build_output_dir}/${implementation_name}_config/openmrs/encounterModifier"
  
  require implementation_config::setup
  
  exec { "copyBeanshellToOpenMRSFolder" :
    command   => "cp -rf ${beanshell_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${beanshell_dir}"
  }

  exec { "copyObsCalculatorToOpenMRSFolder" :
    command   => "cp -rf ${obscalculator_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${obscalculator_dir}"
  }

  exec { "copyPatientMatchingAlgorithmToOpenMRSFolder" :
    command   => "cp -rf ${patient_matching_algorithm_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${patient_matching_algorithm_dir}"
  }

  exec { "copyEncounterModifierScriptsToOpenMRSFolder" :
    command   => "cp -rf ${encounter_modifier_scripts_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${encounter_modifier_scripts_dir}"
  }
 
  exec { "copyordertemplatesToOpenMRSFolder" :
    command   => "cp -rf ${ordertemplates_dir} ${openmrs_dir}",
    provider  => shell,
    path      => "${os_path}",
    onlyif    => "test -d ${ordertemplates_dir}"
  }

  implementation_config::migrations { "implementation_config_migrations_openmrs":
    implementation_name => "${implementation_name}",
    app_name            => "openmrs"
  }

  exec { "copy_implementation_config" :
    command     => "rm -rf ${bahmniConfigDirectory}&& unzip -q -o ${implementation_config::setup::implementation_zip_file} 'openmrs/apps/*' -d ${bahmniConfigDirectory} ${deployment_log_expression}",
    provider    => "shell",
    path        => "${os_path}"
  }

  exec { "set_owner_of_bahmni_config" :
    provider => "shell",
    command => "chown -R ${bahmni_user}:${bahmni_user} ${bahmniConfigDirectory}",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }

  exec { "set_permissions_of_bahmni_config" :
    provider => "shell",
    command => "chmod -R  777 ${bahmniConfigDirectory}",
    path => "${os_path}",
    require => Exec["copy_implementation_config"]
  }
}