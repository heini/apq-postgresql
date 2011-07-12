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
# Important: don't use directories and names with spaces in there. 'if necessary', surround dirs com single quotes
#
########################################
### constant var declarations  #########
########################################
	known_version:=$(shell cat version)
	atual_dir:=$(shell pwd)
	name_base:=$(shell basename $(atual_dir))

### (obs.: can be altered in command line :-)  ###
###  eg: make configure oses=linux,mswindows lib_build_types=dynamic,static \
			system_libs_paths=/usr/source:/usr/local:/lib/got \
			build_with_debug_too=yes

ifndef ($(prefixes))
	prefixes=all:foe:/usr/local
endif

#    eg:  make install prefixes=os:os2:osn:foe:/path1
#    eg2: make install prefixes=os:os2:osn:foe:/path1:/aqui/acola/lah:/usr/local:/pathn
#    You can use wildcard "all" in Os part ;-) and 
#    the build system will (try;) _install_ all compiled libs , for all compiled OSes :-)
#    eg3: make install prefixes=all:foe:/path1:/path2:/pathn
#	Ah! "foe" was used in place of "eof" because (maybe) "eof" can confuse shell

ifndef ($(oses))		# linux,mswindows,darwin,bsd,other
	oses:=linux
endif

ifndef ($(lib_build_types))			# dynamic,static,relocatable
	lib_build_types:=dynamic,static
endif

ifndef ($(build_with_debug_too))	# yes no onlydebug
	build_with_debug_too:=no
endif

ifndef ($(add_compiler_paths))
	add_compiler_paths:=none
endif

ifndef ($(system_libs_paths))		# path1:path2:pathn   
									# max 10 paths. for paths separator use ; or : 
	system_libs_paths:=/usr/lib
endif

ifndef ($(ssl_include_path))
	ssl_include_paths:=/usr/lib/openssl
endif

ifndef ($(pg_config_path))
	pg_config_path:=$(shell dirname $(shell which pg_config || printf "/usr/bin/pg_config" ))
endif

ifndef ($(gprconfig_path))
	gprconfig_path:=$(shell dirname $(shell which gprconfig || printf "/usr/bin/gprconfig" ))
endif

ifndef ($(gprbuild_path))
	gprbuild_path:=$(shell dirname $(shell which gprbuild || printf "/usr/bin/gprbuild" ))
endif


##############################
#### targets #################
##############################

configure:
	@echo $(shell $(atual_dir)/configura.sh "$(oses)" "$(lib_build_types)" "$(add_compiler_paths)" "$(system_libs_paths)" "$(ssl_include_path)" $(pg_config_path) $(gprconfig_path) $(gprbuild_path) "$(build_with_debug_too)")

docs:
	@for docdir in $(DOCS_DIRS); do make -C $$docdir; done

showversion:
	@echo $(known_version)
	
force:
