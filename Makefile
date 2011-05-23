# Makefile for the AW_Lib
#
# @author Marcelo Coraça de Freitas <marcelo.batera@gmail.com>
#
# @author Daniel Norte de Moraes <danielcheagle@gmail.com>

# 1) rewrite version (more or less from scratch) for use gprbuild and Cia
# obs. you can substitute gprbuild with gprmake, if you can't use gprbuild (but not tested yet )
#
# "estoy aqui" :-)
# 23 may 2011 08:33:59 GMT-3
# New and clean update for the Build System.
# Added cross-compiling and static and shared simultaneos generation
#

ifndef ($(SYSTEM_LIBS))
	SYSTEM_LIBS=/usr/lib
endif


#VERSION=$(shell cat version)
ATUALDIR=$(shell pwd)
#DIRLIB_POSTGREHELP:=$(ATUALDIR)/lib-c

PQ_INCLUDE=$(shell pg_config --includedir)

INCLUDE_FILES=src*/*

ifndef ($(SSL_INCLUDE))
	SSL_INCLUDE=$(SYSTEM_LIBS)/openssl
endif


ifndef ($(PREFIX))
	PREFIX=/usr/local
endif

ifndef ($(INCLUDE_PATH))
	INCLUDE_PATH=$(PREFIX)/include/$(shell basename $(ATUALDIR))
endif

ifndef ($(LIB_PATH))
	LIB_PATH=$(PREFIX)/lib
endif

ifndef ($(GPR_PATH))
	GPR_PATH=$(LIB_PATH)/gnat
endif

ifndef ($(GPRBUILD))
	GPRBUILD=gprbuild
endif

ifndef ($(GPR_INCLUDE_PATH))
	GPR_INCLUDE_PATH=$(INCLUDE_PATH)
endif

ifndef ($(GPR_LIB_PATH))
	GPR_LIB_PATH=$(LIB_PATH)
endif

all: default.cgpr madegpr
	$(shell $(GPRBUILD) -Papq_postgresql.gpr -cargs -I $(PQ_INCLUDE) -I $(SSL_INCLUDE) )



# IMPORTANT: for the guys making comercial software,
#consider altering the parameters of _gprconfig below_ if necessary,
#for oblige gprbuild to _use_ the compilers,linkers etc that permit
#a comercial version of your resultant binary :-) for e.g. use a Ada (C, etc) runtime
#that permit this comercial use.
#
# An Very Very Very Interesting Point (not just for license lawyers) is that gcc4.4+ switched
#to GPL v3.0+RunTimeException, similar in the spirit to GMGPL :-) (of course gcc4.4+ includes Ada, too)

default.cgpr:
	gprconfig --batch --config Ada,,default  --config C -o $@

madegpr:
	@echo "Making project_files";
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR2=\"-L$(SYSTEM_LIBS)\"" apq_postgresqlhelp_bd.gpr.in apq_postgresqlhelp_bd.gpr
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR2=\"-L$(SYSTEM_LIBS)\"" apq_postgresqlhelp_bs.gpr.in apq_postgresqlhelp_bs.gpr
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR=\"-L$(DIRLIB_POSTGREHELP)\"" apq-postgresql_bd.gpr.in apq-postgresql_bd.gpr
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR=\"-L$(DIRLIB_POSTGREHELP)\"" apq-postgresql_bs.gpr.in apq-postgresql_bs.gpr
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR=\"-L$(DIRLIB_POSTGREHELP)\"" postgresql_bd.gpr.in postgresql_bd.gpr
	gnatprep "-Dversion=\"$(VERSION)\"" "-DLIBDIR=\"-L$(DIRLIB_POSTGREHELP)\"" postgresql_bs.gpr.in postgresql_bs.gpr
	@echo version:=\"$(VERSION)\" > gpr/gnatprep.def
	@echo lib_path:=\"$(GPR_LIB_PATH)\" >> gpr/gnatprep.def
	@echo include_path:=\"$(GPR_INCLUDE_PATH)\" >> gpr/gnatprep.def
	gnatprep gpr/apq-postgresql.gpr.in gpr/apq-postgresql.gpr gpr/gnatprep.def
	gnatprep gpr/apq-postgresql_static.gpr.in gpr/apq-postgresql_static.gpr gpr/gnatprep.def
	gnatprep gpr/apq-postgresql_shared.gpr.in gpr/apq-postgresql_shared.gpr gpr/gnatprep.def

install: includeinstall libinstall gprinstall

gprinstall:
	@echo Installing GPR files..
	install -d $(GPR_PATH)
	install gpr/*.gpr -t $(GPR_PATH)

includeinstall:
	@echo Installing include and source files...
	install -d $(INCLUDE_PATH)
	install $(INCLUDE_FILES) -t $(INCLUDE_PATH)

libinstall:
	@echo Installing library files...
	install -d $(LIB_PATH)
	install -d $(GPR_LIB_PATH)/ada/apq-postgresql/shared
	install -d $(GPR_LIB_PATH)/ada/apq-postgresql/static
	install lib/* -t $(LIB_PATH)
	install lib-c/* -t $(LIB_PATH)
	install lib-c-static/* -t $(LIB_PATH)
	install lib-static/* -t $(LIB_PATH)
	install -m0555 lib_ali/* -t $(GPR_LIB_PATH)/ada/apq-postgresql/shared
	install -m0555 lib_ali_static/* -t $(GPR_LIB_PATH)/ada/apq-postgresql/static

clean: force
	gprclean -Papq_postgresqlhelp_bs.gpr
	gprclean -Papq_postgresqlhelp_bd.gpr
	gprclean -Ppostgresql_bs.gpr
	gprclean -Ppostgresql_bd.gpr
	rm apq_postgresqlhelp_bd.gpr
	rm apq_postgresqlhelp_bs.gpr
	rm apq-postgresql_bd.gpr
	rm apq-postgresql_bs.gpr
	rm postgresql_bd.gpr
	rm postgresql_bs.gpr
	rm default.cgpr
	rm gpr/gnatprep.def
	rm gpr/*.gpr

docs:
	@for docdir in $(DOCS_DIRS); do make -C $$docdir; done

showversion:
	@echo $(VERSION)

force:
