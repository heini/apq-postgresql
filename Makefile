## Makefile for libapq-postgresql and associated files
#
# @author Marcelo Coraça de Freitas <marcelo.batera@gmail.com>
#
# @author Daniel Norte de Moraes <danielcheagle@gmail.com>
#
# "estoy aqui" :-)
# 23 may 2011 08:33:59 GMT-3
# New and clean update for the Build System.
# Added cross-compiling and static and shared simultaneos generation
#
# 06 july 2011 06:32:23 GMT-3
# rewrite from scratch.
# New and clean update for the Build System.
# Added cross-compiling and static and shared simultaneos generation
#
#
# IMPORTANT: for the guys making comercial software,
#consider altering the parameters of _gprconfig_ if necessary,
#for oblige gprbuild to _use_ the compilers,linkers etc that permit
#a comercial version of your resultant binary :-) for e.g. use a Ada (C, etc) runtime
#that permit this comercial use.
#
# An Very Very Very Interesting Point (not just for license lawyers) is that gcc4.4+ switched
#to GPL v3.0+RunTimeException, similar in the spirit to GMGPL :-) (of course gcc4.4+ includes Ada, too)
#
#
########################################
### constant var declarations  #########
########################################
	known_oses_list="linux mswindows darwin bsd other"
	known_build_types="dynamic static relocable"
	known_version=$(shell cat version)
	atual_dir=$(shell pwd)
	name_base=$(shell basename $(atual_dir))
#    ssl_include:=$(system_libs)/openssl
#    eg:  make install --prefixes="os:os2:osn:foe:/path1"
#    eg2: make install --prefixes="os:os2:ons:foe:/path1:/aqui/acola/lah:/usr/local:/pathn"
#    You can use wildcard "all" in Os part ;-) and 
#    the build system will (try;) install all compiled libs , for all compiled OSes :-)
#    eg3: make install --prefixes="all:foe:/path1:/path2:/pathn"
#
ifndef ($(prefixes))
	prefixes='all:foe:/usr/local'
endif

ifndef ($(oses))
	oses='linux'
endif

ifndef ($(lib_build_types))
	lib_build_types='dynamic,static'
endif

ifndef ($(add_compiler_paths))
	add_compiler_paths=''
endif

ifndef ($(system_libs_paths))
	system_libs_paths='/usr/lib'
endif

ifndef ($(ssl_include_paths))
	ssl_include_paths='/usr/lib/openssl'
endif

ifndef ($(pg_config_path_cmd))
	pg_config_path_cmd='/usr/bin/pg_config'
endif

ifndef ($(gprconfig_path_cmd))
	gprconfig_path_cmd='/usr/bin/gprconfig'
endif

ifndef ($(gprbuild_path_cmd))
	gprbuild_path_cmd='/usr/bin/gprbuild'
endif

FUN2=$(shell my_oses=$(11) ; \
		my_libtyps=$(12) ; \
		my_compilers_paths=$(13) ; \
		my_system_libs_paths=$(14) ; \
		my_ssl_incl_paths=$(15) ; \
		my_pg_config_path_cmd=$(16) ; \
		my_gprbuild_path_cmd=$(17) ; \
		my_gprconfig_path_cmd=$(18) ; \
		my_known_oses_list=$(1) ; \
		my_known_build_types=$(2) ; \
		my_known_version=$(3) ; \
		my_atual_dir=$(4) ; \
		my_tmp=$${my_oses,,} ; \
	)

configura:
	$(call FUN2,"$(known_oses_list)" ,"$(known_build_types)" ,"$(known_version)" ,"$(atual_dir)" ,"reserved" ,"reserved" ,"reserved" ,"reserved" ,"reserved" ,"reserved" \
		,"$(oses)" ,"$(lib_build_types)" ,"$(add_compiler_paths)" ,"$(system_libs_paths)" ,"$(ssl_include_paths)" ,"$(pg_config_path_cmd)" \
		,"$(gprbuild_path_cmd)" ,"$(gprconfig_path_cmd)" ,"reserved" ,"reserved" ,"reserved" ,"reserved" \
		)

docs:
	@for docdir in $(DOCS_DIRS); do make -C $$docdir; done

showversion:
	@echo $(known_version)


force:
