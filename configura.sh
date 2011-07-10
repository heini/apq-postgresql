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
	printf 'configura "OSes" "libtypes,libtypes_n" "paths_for_compiler:paths_for_compiler_n" "system_libs_paths:system_libs_paths_n"  "ssl_include_paths" "path_pg_config"  "path_gprconfig"  "path_gprbuild"  "with_debug_too"  \n'
	exit 1
fi;

local my_oses=""
local    _oses="$1"
local my_libtypes=""
local	_libtypes="$2"
local my_version=$(cat version)
local my_atual_dir=$(pwd)
local	_base_name=""
local my_paths_for_compiler="$3"

local my_system_libs_paths=""
local	_system_libs_paths="$4"

local my_ssl_include_paths=""
local	_ssl_include_paths="$5"
local my_pg_config_path=""
local	_pg_config_path="$6"
local my_gprconfig_path=""
local	_gprconfig_path="$7"
local my_gprbuild_path=""
local	_gprbuild_path="$8"

local my_with_debug_too=""
local	_with_debug_too="$9"

local ifsbackup="$IFS"

# fix me if necessary:
# need more sanatization

my_system_libs_paths="$_system_libs_paths"
my_ssl_include_paths="$_ssl_include_paths"
my_pg_config_path="$_pg_config_path"
my_gprconfig_path="$_gprconfig_path"
my_gprbuild_path="$_gprbuild_path"

_oses=${_oses:-"linux"}${_oses}
_oses=${_oses,,}	# to_lower. min bash v4.0

for r in linux mswindows darwin bsd other
do
	case $_oses in
		*all*) my_oses="linux,mswindows,darwin,bsd,other";
			break ;;
		*"$r"*) my_oses=${my_oses:+"{my_oses},"}${r} ;;
	esac
done

_libtypes=${_libtypes:-"dynamic,static"}${_libtypes}
_libtypes=${_libtypes,,}   # to_lower

unset r
for r in static dynamic relocatable
do
	case $_libtypes in
		*all*)	my_libtypes="static,dynamic,relocatable" ;
			break ;;
		*"$r"*)	my_libtypes=${my_libtypes:+"${my_libtypes},"}${r} ;;
	esac
done

my_libtypes=${my_libtypes:-"static,dynamic"}${my_libtypes}

my_system_libs_paths=${_system_libs_paths:-"/usr/lib"}${_system_libs_paths}

my_ssl_include_paths=${_ssl_include_paths:-"/usr/lib/openssl"}${_ssl_include_paths}

my_with_debug_too=${_with_debug_too,,}	#to_lower

case $my_with_debug_too in
	*yes*)	my_with_debug_too="normal,debug" ;;
	*)		my_with_debug_too="normal" ;;
esac

libdir2=""
libdir3=""

IFS=";:"
for alibdirsystem in $my_system_libs_paths
do
	libdir3="${libdir3:+${libdir3},}\"L${alibdirsystem}\""
	libdir2="${libdir2:+${libdir2},}\"L${alibdirsystem}\""
done

my_system_libs_paths="$libdir2"
libdir2 = "( $libdir2  )"	#note: min of two spaces before ")"  :-)
libdir3 = "( $libdir3  )"	#note: min of two spaces before ")"  :-)

IFS="$ifsbackup"

local made_dirs="$my_atual_dir/build/"

IFS=","

for sist_oses in $my_oses
do

	for libbuildtype in $my_libtypes
	do

		for debuga in $my_with_debug_too	# normal,debug
		do
			my_tmp="$made_dirs/$sist_oses/$libbuildtype/$debuga"
			mkdir -p $my_tmp
			IFS="\n"
			{	printf	"$my_tmp\n"
				printf	"$debuga\n"
				printf	"$libbuildtype\n"
				printf	"$sist_oses\n"
				printf	"$my_paths_for_compiler\n"
				printf	"$my_gprconfig_path\n"
				printf	"$my_gprbuild_path\n"
				printf	"$my_pg_config_path\n"
			}	> $my_tmp/kov.log

			{	printf	"version:=\"${my_version}\"\n"
				printf	"system_libs:=$libdir3  \n"		#min two spaces before "\n" because quotes
				printf	"myhelpsource:=\"$my_atual_dir/src-c/\"  \n"
				printf	"mysource:=\"$my_atual_dir/src/\"  \n"	#min two spaces before "\n" because quotes
			}	> $my_tmp/kov.def

			IFS="$ifsbackup"
			gnatprep $my_atual_dir/apq_postgresql_version.gpr.in  $my_tmp/apq_postgresql_version.gpr  $my_tmp/kov.def
			cp $my_atual_dir/apq-postgresql.gpr $my_tmp/
			cp $my_atual_dir/apq_postgresqlhelp.gpr $my_tmp/

			IFS=","
			for support_dirs in obj,lib_ali,ali,obj_c,lib_ali_c,ali_c
			do
				mkdir -p $made_dirs/$sist_oses/$libbuildtype/$debuga/$support_dirs

			done # support_dirs
		done # debuga
	done # libbuildtype
done # sist_oses

IFS="$ifsbackup"

exit 0;   # end ;-)




