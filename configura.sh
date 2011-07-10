#!/bin/sh
#: title	: configura
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: made configuration for posterior compiling by gprbuild.
#: Description: You don't need run this script manually.
#: Options	:  "OSes" "libtypes,libtypes_n" "paths_for_compiler:paths_for_compiler_n"  \
	#		"system_libs_paths:system_libs_paths_n"  "ssl_include_paths" "path_pg_config"  \
	#		"path_gprconfig"  "path_gprbuild"  "with_debug_too"


if [ $# -ne 9 ]; then
	printf 'configura "OSes" "libtypes,libtypes_n" "paths_for_compiler:paths_for_compiler_n" "system_libs_paths:system_libs_paths_n"  "ssl_include_paths" "path_pg_config"  "path_gprconfig"  "path_gprbuild"  "with_debug_too"  '
	exit 1
fi;


