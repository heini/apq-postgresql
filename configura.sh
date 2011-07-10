#!/bin/bash
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
	printf ' You dont need use it by hand. read INSTALL for more info and direction.  \n'
	printf 'configura "OSes" "libtypes,libtypes_n" "paths_for_compiler:paths_for_compiler_n" "system_libs_paths:system_libs_paths_n"  "ssl_include_paths" "path_pg_config"  "path_gprconfig"  "path_gprbuild"  "with_debug_too"  \n'
	exit 1
fi;

ifsbackup="$IFS"


my_version=$(cat version)
my_atual_dir=$(pwd)

IFS=

my_oses=
_oses=$1
my_libtypes=
_libtypes=$2
_base_name=
my_paths_for_compiler=$3

my_system_libs_paths=
_system_libs_paths=$4

my_ssl_include_paths=
_ssl_include_paths=$5
my_pg_config_path=
_pg_config_path=$6
my_gprconfig_path=
_gprconfig_path=$7
my_gprbuild_path=
_gprbuild_path=$8

my_with_debug_too=
_with_debug_too=$9

# fix me if necessary:
# need more sanatization

my_system_libs_paths=$_system_libs_paths
my_ssl_include_paths=$_ssl_include_paths
my_pg_config_path=$_pg_config_path
my_gprconfig_path=$_gprconfig_path
my_gprbuild_path=$_gprbuild_path

IFS="$ifsbackup"

_oses=${_oses:-linux}${_oses}
_oses=${_oses,,}
# ${var,,) -> to_lower(var). min bash v4.0

for r in linux mswindows darwin bsd other
do
	case $_oses in
		*all*) my_oses=linux,mswindows,darwin,bsd,other
			break
			;;
		*"$r"*) my_oses=${my_oses:+${my_oses},}$r
			;;
	esac
done

_libtypes=${_libtypes,,}
# to_lower

for r2 in static dynamic relocatable
do
	case $_libtypes in
		*all*)	my_libtypes=static,dynamic,relocatable
			break
			;;
		*"$r2"*)	my_libtypes=${my_libtypes:+${my_libtypes},}$r2
			;;
	esac
done

my_libtypes=${my_libtypes:-static,dynamic}$my_libtypes

my_system_libs_paths=${_system_libs_paths:-/usr/lib}$_system_libs_paths

my_ssl_include_paths=${_ssl_include_paths:-/usr/lib/openssl}$_ssl_include_paths

_with_debug_too=${_with_debug_too,,}
#to_lower

case $_with_debug_too in
	*yes*)	my_with_debug_too=normal,debug
		;;
	*no*)	my_with_debug_too=normal
		;;
esac

my_with_debug_too=${my_with_debug_too:-normal}$my_with_debug_too

libdir2=
libdir3=

IFS=";:$ifsbackup"
for alibdirsystem in $my_system_libs_paths
do
	libdir2="${libdir2:+${libdir2},}\" L${alibdirsystem}\" "
	libdir3="${libdir3:+$libdir3} L${alibdirsystem} "
done

my_system_libs_paths="$libdir3"
libdir2="( ${libdir2}  )"
#note: min of two spaces before ")"  :-)

IFS=",$ifsbackup"

made_dirs=${my_atual_dir}/build


for sist_oses in $my_oses
do
	for libbuildtype in $my_libtypes
	do
		for debuga in $my_with_debug_too
		do
			my_tmp="$made_dirs"/$sist_oses/$libbuildtype/$debuga
			mkdir -p "$my_tmp"

				#min two spaces before "\n" because quotes
			{	printf	"$my_tmp  \n"
				printf	"$debuga  \n"
				printf	"$libbuildtype  \n"
				printf	"$sist_oses  \n"
				printf	"$my_paths_for_compiler  \n"
				printf	"$my_gprconfig_path  \n"
				printf	"$my_gprbuild_path  \n"
				printf	"$my_pg_config_path  \n"
			}>"$my_tmp/kov.log"

				#min two spaces before "\n" because quotes
			{	printf	"version:=\"$my_version\"  \n"
				printf	"system_libs:=$libdir2  \n"	
				printf	"myhelpsource:=\"$my_atual_dir/src-c/\"  \n"
				printf	"mysource:=\"$my_atual_dir/src/\"  \n"
				printf	"basedir:=\"$my_atual_dir/build\"  \n"
			}>"$my_tmp/kov.def"

			gnatprep "$my_atual_dir/apq_postgresql_version.gpr.in"  "$my_tmp/apq_postgresql_version.gpr"  "$my_tmp/kov.def"
			cp "$my_atual_dir/apq-postgresql.gpr"  "$my_tmp/"
			cp "$my_atual_dir/apq_postgresqlhelp.gpr"  "$my_tmp/"

			for support_dirs in obj lib_ali ali,obj_c lib_ali_c ali_c
			do
			
				mkdir -p "$my_tmp"/$support_dirs
			

			done # support_dirs
		done # debuga
	done # libbuildtype
done # sist_oses

IFS="$ifsbackup"

exit 0;   # end ;-)




