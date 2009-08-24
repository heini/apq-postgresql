# Makefile for the AW_Lib
#
# @author Marcelo Coraça de Freitas <marcelo.batera@gmail.com> 


# Set those variables when building for Windows or when you have
# PostgreSQL installed in some hidden location.

#POSTGRESQL_PATH=/c/Program Files/PostgreSQL/8.3/
#POSTGRESQL_INCLUDE=${POSTGRESQL_PATH}/include
#POSTGRESQL_LIB=${POSTGRESQL_PATH}/lib

POSTGRESQL_PATH=/c/postgresql/
POSTGRESQL_INCLUDE=${POSTGRESQL_PATH}/include
POSTGRESQL_LIB=${POSTGRESQL_PATH}/lib

#OUTPUT_NAME is the name of the compiled library.
ifeq ($(OS), Windows_NT)
	OUTPUT_NAME=apq-postgresqlhelp.dll
else
	OUTPUT_NAME=libapq-postgresqlhelp.so
endif


PROJECT_FILES=apq-postgresql.gpr
GPR_FILES=apq-postgresql.gpr


INCLUDE_FILES=src*/*

include Makefile.include



pre_libs: c_libs

pos_libs:


c_libs: c_objs
	cd lib && gcc -shared ../obj-c/numeric.o ../obj-c/notices.o -o $(OUTPUT_NAME) -L"${POSTGRESQL_LIB}" -lpq

c_objs:
	cd obj-c && gcc -fPIC -I/usr/include/postgresql/ -I../src-c ../src-c/numeric.c -c -o numeric.o && gcc -fPIC -I"${POSTGRESQL_INCLUDE}" -I../src-c ../src-c/notices.c -c -o notices.o



extra_clean:
	@rm -f obj-c/* lib/*

