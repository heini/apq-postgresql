#!/bin/bash
#: title	: base
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: base scripts and functions for configuring,compiling and installing.
#: Description: You don't need run this script manually.
#: Description: For It use makefile targets. See INSTALL file.

if [ $# -eq 0 ]; then
	printf "I need minimum of 1 options\n"
	exit 1;
fi;

case ${1,,} in  
	"configure" ) my_commande='configuring' ;;
	"compile" ) my_commande='compilling' ;;
	"install" ) my_commande='installing' ;;
	"clean" ) my_commande='cleaning' ;;
	"distclean" ) my_commande='dist_cleaning' ;;
	* ) printf "I dont known this command take 1 :-\)\n" ;
		exit 1
		;;
esac;

shift 1 ;

global_ifs_bk="$IFS"

##################################
##### support functions ##########
##################################

#####################
### sanitization  ###
#####################

_choose_so(){
#: title	: _choose_so
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: sanitize list of Systems Operations separated by ","
#: Options	:  "OSes"

local _oses=$1
_oses=${_oses:=linux}
_oses=${_oses,,}
local my_oses=
local a=
for a in linux mswindows darwin bsd other
do
	case $_oses in
		*all*) my_oses=linux,mswindows,darwin,bsd,other
			break
			;;
		*"$a"*) my_oses=${my_oses:+${my_oses},}$a
			;;
	esac
done
my_oses=${my_oses:=linux}
printf $my_oses

} # end 

_choose_libtype(){
#: title	: _choose_libtype
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: sanitize list of lib types separated by ","
#: Options	: "libtype,libtype_n"

local _libtypes=$1
_libtypes=${_libtypes:=dynamic,static}
_libtypes=${_libtypes,,}
local my_libtypes=
local a=
for a in static dynamic relocatable
do
	case $_libtypes in
		*all*) my_libtypes=static,dynamic,relocatable
			break
			;;
		*"$a"*) my_libtypes=${my_libtypes:+${my_libtypes},}$a
			;;
	esac
done
my_libtypes=${my_libtypes:=dynamic,static}
printf $my_libtypes

} # end 

_choose_debug(){
	echo stub
}


##################################
##### target functions ##########
##################################

_configure(){
#: title	: configure
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: made configuration for posterior compiling by gprbuild.
#: Description: You don't need run this script manually.
#: Options	:  "OSes" "libtypes,libtypes_n" "compiler_path1:compiler_pathn"  \
	#		"system_libs_path1:system_libs_pathn"  "ssl_include_paths" "pg_config_path"  \
	#		"gprconfig_path"  "gprbuild_path"  "with_debug_too"


if [ $# -ne 9 ]; then
	printf ' You dont need use it by hand. read INSTALL for more info and direction.' ; printf "\n" ;
	printf 'configura "OSes" "libtype,libtype_n" "compiler_path1:compiler_path_n" "system_libs_path1:system_libs_paths_n"  "ssl_include_paths" "pg_config_path"  "gprconfig_path"  "gprbuild_path"  "with_debug_too" ' ; printf "\n" ;
	
	exit 1
fi;

local ifsbackup="$IFS"
local IFS="$ifsbackup"

local my_version=$(cat version)
local my_atual_dir=$(pwd)
local my_oses=$(_choose_so "$1" )
local my_libtypes=$(_choose_libtype "$2" )

local _base_name=
local my_compiler_paths=$3
local my_system_libs_paths=
local _system_libs_paths=$4
local my_ssl_include_paths=
local _ssl_include_paths=$5
local my_pg_config_path=
local _pg_config_path=$6
local my_gprconfig_path=
local _gprconfig_path=$7
local my_gprbuild_path=
local _gprbuild_path=$8
local my_with_debug_too=
local _with_debug_too=$9

# fix me if necessary:
# need more sanitization
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

local at_count=
local max_count=11

IFS=";:$ifsbackup"
for alibdirsystem in $_system_libs_paths
do
	[ ${at_count:=1} -ge ${max_count:=11} ] && break;
	madeit=" lib_system$at_count=\"-L$alibdirsystem\"  "
	eval $madeit
	at_count=$(( $at_count + 1 ))
done
IFS=",$ifsbackup"

local made_dirs=${my_atual_dir}/build

for sist_oses in $my_oses
do
	for libbuildtype in $my_libtypes
	do
		for debuga in $my_with_debug_too
		do
			my_tmp="$made_dirs"/$sist_oses/$libbuildtype/$debuga
			mkdir -p "$my_tmp"

			IFS="$ifsbackup"  # the min one blank line below here _is necessary_ , otherwise IFS will affect _only_ next command_ ;-)

			#min two spaces before "\n" because quotes
			{	printf	"$my_tmp  \n"
				printf	"$debuga  \n"
				printf	"$libbuildtype  \n"
				printf	"$sist_oses  \n"
				printf	"$my_compiler_paths  \n"
				printf	"$my_gprconfig_path  \n"
				printf	"$my_gprbuild_path  \n"
				printf	"${my_pg_config_path}  \n"
			}>"$my_tmp/kov.log"

			local madeit3=
			local at_count_tmp=
			local madeit2=

				#min two spaces before "\n" because quotes
			{	printf	"version:=\"$my_version\"  \n"
				printf	"myhelpsource:=\"$my_atual_dir/src-c/\"  \n"
				printf	"mysource:=\"$my_atual_dir/src/\"  \n"
				printf	"basedir:=\"$my_atual_dir/build\"  \n"	
				while [ ${at_count_tmp:=1} -lt ${at_count:=11} ]
				do
					madeit2="lib_system$at_count_tmp" ;
					madeit3="${madeit3:+${madeit3},} \$$madeit2 " ;
					printf  "${madeit2}:=\"${!madeit2}\"  \n" ;				
					at_count_tmp=$(( $at_count_tmp + 1 )) ;
				done ;
				printf "\n"

			}>"$my_tmp/kov.def"

			cat "$my_atual_dir/apq_postgresql_version_part1.gpr.in.in" > "$my_tmp/apq_postgresql_version.gpr.in"
			printf  'system_libs  := ( ) & ( ' >> "$my_tmp/apq_postgresql_version.gpr.in" ;
			printf  " $madeit3 " >> "$my_tmp/apq_postgresql_version.gpr.in" ;
			printf  ' ) ' >> "$my_tmp/apq_postgresql_version.gpr.in" ;
			cat "$my_atual_dir/apq_postgresql_version_part3.gpr.in.in" >> "$my_tmp/apq_postgresql_version.gpr.in"
					

			gnatprep "$my_tmp/apq_postgresql_version.gpr.in"  "$my_tmp/apq_postgresql_version.gpr"  "$my_tmp/kov.def"
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

} #end _configure

####################################
######   operative part   ##########
####################################

case $my_commande in
	'configuring' )  [ $# -eq 9 ] && _configure "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || printf "configure need nine\(9\) options\n" ; exit 1
		;;
	'compilling' )  echo "EBA"
		;;
	'installing' ) 
		;; 
	'cleaning' ) 
		;;
	'dist_cleaning' )  ;;
	*  ) printf "I dont known this command :-\)\n" ;
		printf "_${my_commande}_\n"
		exit 1
		;;
esac
