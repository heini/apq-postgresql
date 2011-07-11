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
#known_oses_list="linux,mswindows,darwin,bsd,other"
#known_build_types="dynamic,static,relocable"

	known_version:=$(shell cat version)
	atual_dir:=$(shell pwd)
	name_base:=$(shell basename $(atual_dir))

ifndef ($(prefixes))
	prefixes='all:foe:/usr/local'
endif

#    eg:  make install --prefixes="os:os2:osn:foe:/path1"
#    eg2: make install --prefixes="os:os2:ons:foe:/path1:/aqui/acola/lah:/usr/local:/pathn"
#    You can use wildcard "all" in Os part ;-) and 
#    the build system will (try;) install all compiled libs , for all compiled OSes :-)
#    eg3: make install --prefixes="all:foe:/path1:/path2:/pathn"
#

ifndef ($(oses))
	oses:='linux'
endif

ifndef ($(lib_build_types))
	lib_build_types:='dynamic,static'
endif

ifndef ($(build_with_debug_too))	# yes no onlydebug
	build_with_debug_too:='no'
endif

ifndef ($(add_compiler_paths))
	add_compiler_paths:=''
endif

ifndef ($(system_libs_paths))		# max 10 paths
	system_libs_paths:='/usr/lib'
endif

ifndef ($(ssl_include_paths))
	ssl_include_paths:='/usr/lib/openssl'
endif

ifndef ($(pg_config_path))
	pg_config_path:='/usr/bin'
endif

ifndef ($(gprconfig_path))
	gprconfig_path:='/usr/bin'
endif

ifndef ($(gprbuild_path))
	gprbuild_path:='/usr/bin'
endif

##############################
#### targets #################
##############################

configura:
	@echo $(shell $(atual_dir)/configura.sh "$(oses)" "$(lib_build_types)" "$(add_compiler_paths)" "$(system_libs_paths)" "$(ssl_include_paths)" "$(pg_config_path)" "$(gprconfig_path)" "$(gprbuild_path)" "$(build_with_debug_too)")

docs:
	@for docdir in $(DOCS_DIRS); do make -C $$docdir; done

showversion:
	@echo $(known_version)


force:
