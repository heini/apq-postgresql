Rationale of $(libapq-postgresql_COMPILING_HOME_SRC)/log/

1.File) lib_installed_and_in.all
1.R) contain info about _ALL_  success full "make install"

2.FILE)	 lib_installed_and_in.backup_unparsed
2.R)  for operations that will be necessary

3.FILE) lib_installed_and_in.last_before_clean
3.R) contain info about all successfull "make install" before a hit "make clean"

4.FILE) lib_installed_and_in.last_before_install
4.R) contain info about all successfull "make" _Before_ a hit "make install"

3.Make)
	"if success = true then"
	echo  "$lib_and_cia" >> ./lib_installed_and_in.last_before_install

4.Make Install)
	process ./lib_installed_and_in.last_before_install and use it to install
	"if success = true then"
	echo ./lib_installed_and_in.last_before_install >> ./lib_installed_and_in.last_before_clean
	echo ./lib_installed_and_in.last_before_install >> ./lib_installed_and_in.all
	echo -n "" > ./lib_installed_and_in.last_before_install
5.Make Clean)
	$(shell rm ../static ../dynamic ../relocateble -rf



