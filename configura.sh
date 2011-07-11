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
_pg_config_path=${_pg_config_path:=/usr/bin}
#_pg_config_path=${_pg_config_path//[''``]/""}
my_pg_config_path=$_pg_config_path

_gprconfig_path=${_gprconfig_path:=/usr/bin}
my_gprconfig_path=$_gprconfig_path

_gprbuild_path=${_gprbuild_path:=/usr/bin}
my_gprbuild_path=$_gprbuild_path

_ssl_include_paths=${_ssl_include_paths:=/usr/lib/openssl}
my_ssl_include_paths=${_ssl_include_paths}

_system_libs_paths=${_system_libs_paths:=/usr/lib}

_oses=${_oses:=linux}
_oses=${_oses,,}
# ${var,,} -> to_lower(var). min bash v4.0
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
_libtypes=${_libtypes:=dynamic,static}
_libtypes=${_libtypes,,}
# ${var,,} -> to_lower(var). min bash v4.0
for q in static dynamic relocatable
do
	case $_libtypes in
		*all*)	my_libtypes=static,dynamic,relocatable
			break
			;;
		*$q*)	my_libtypes=${my_libtypes:+${my_libtypes},}$q
			;;
	esac
done
_with_debug_too=${_with_debug_too:=no}
_with_debug_too=${_with_debug_too,,}
case $_with_debug_too in
	*onlydebug*)	my_with_debug_too=debug
		;;
	*yes*)	my_with_debug_too=normal,debug
		;;
	*no*)	my_with_debug_too=normal
		;;
esac

libdir2=
libdir3=
lib_system1=
lib_system2=
lib_system3=
lib_system4=
lib_system5=
lib_system6=
lib_system7=
lib_system8=
lib_system9=
lib_system10=

unset z

IFS=";:$ifsbackup"
for alibdirsystem in $_system_libs_paths
do
	[ ${z:=1} -gt 10 ] && break;
	madeit=" lib_system$z=\"-L${alibdirsystem}\"  "
	eval $madeit
	z=$(( $z + 1 ))
done
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
			
			IFS="$ifsbackup"

			#min two spaces before "\n" because quotes
			{	printf	"$my_tmp  \n"
				printf	"$debuga  \n"
				printf	"$libbuildtype  \n"
				printf	"$sist_oses  \n"
				printf	"$my_paths_for_compiler  \n"
				printf	"$my_gprconfig_path  \n"
				printf	"$my_gprbuild_path  \n"
				printf	"${my_pg_config_path}  \n"
			}>"$my_tmp/kov.log"

				#min two spaces before "\n" because quotes
			{	printf	"version:=\"$my_version\"  \n"
				printf  "system_lib1:=\"$lib_system1\"  \n"
				printf  "system_lib2:=\"$lib_system2\"  \n"
				printf  "system_lib3:=\"$lib_system3\"  \n"
				printf  "system_lib4:=\"$lib_system4\"  \n"
				printf  "system_lib5:=\"$lib_system5\"  \n"
				printf  "system_lib6:=\"$lib_system6\"  \n"
				printf  "system_lib7:=\"$lib_system7\"  \n"
				printf  "system_lib8:=\"$lib_system8\"  \n"
				printf  "system_lib9:=\"$lib_system9\"  \n"
				printf  "system_lib10:=\"$lib_system10\"  \n"
				printf	"myhelpsource:=\"$my_atual_dir/src-c/\"  \n"
				printf	"mysource:=\"$my_atual_dir/src/\"  \n"
				printf	"basedir:=\"$my_atual_dir/build\"  \n"
			}>"$my_tmp/kov.def"

			gnatprep "$my_atual_dir/apq_postgresql_version.gpr.in"  "$my_tmp/apq_postgresql_version.gpr"  "$my_tmp/kov.def"
			cp "$my_atual_dir/apq-postgresql.gpr"  "$my_tmp/"
			cp "$my_atual_dir/apq_postgresqlhelp.gpr"  "$my_tmp/"

			IFS=",$ifsbackup"

			for support_dirs in obj lib_ali ali obj_c lib_ali_c ali_c
			do			
				mkdir -p "$my_tmp"/$support_dirs
			done # support_dirs
		done # debuga
	done # libbuildtype
done # sist_oses
IFS="$ifsbackup"

exit 0;   # end ;-)

