require 'brewkit'

class Sloccount <Formula
  @url='http://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz'
  @homepage='http://www.dwheeler.com/sloccount/'
  @md5='09abd6e2a016ebaf7552068a1dba1249'

  def patches
      # We create the install dir or install falls over
      # We delete makefile.orig or patch falls over
      DATA
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/makefile b/makefile
index 0c029f1..8e303e2 100644
--- a/makefile
+++ b/makefile
@@ -164,6 +164,7 @@ c_lines: C_LINES.C
 
 
 install_programs: all
+	$(INSTALL_A_DIR) $(INSTALL_DIR)
 	$(INSTALL) $(EXECUTABLES) $(INSTALL_DIR)
 
 uninstall_programs:
diff --git a/makefile.orig b/makefile.orig
deleted file mode 100644
index e2753d8..0000000
--- a/makefile.orig
+++ /dev/null
@@ -1,222 +0,0 @@
-# Makefile for SLOCCount.
-# (C) Copyright David A. Wheeler 2000-2002.
-# Licensed under the GPL; see sloccount.html for license information.
-# My thanks to John Clezy, who provided the modifications to this makefile
-# to make sloccount work on Windows using Cygwin.
-
-
-# You may need to change the following options to install on your machine:
-
-# Set this for where to store the man pages and executables.
-# If you want to store this as part of an official distribution,
-# change this to "/usr":
-PREFIX=/usr/local
-
-# Set "EXE_SUFFIX" to ".exe" if you're running on Windows, like this:
-# EXE_SUFFIX=.exe
-EXE_SUFFIX=
-
-# Set this to your C compiler, if it's not "gcc"; a likely alternative is "cc".
-# The "-Wall" option turns on warnings in gcc.  gcc users might also want
-# to consider using "-Werror", which turns warnings into errors.
-CC=gcc -Wall
-
-# Set this to the name of your "install" program.  On some systems,
-# "install -C" would be useful (so unchanged files won't be modified),
-# but not all systems support this install option.  "Install" should work
-# for any Unix-like system as well as for Cygwin.
-# "INSTALL_A_DIR" is the command to create a directory in the first place.
-INSTALL=install
-INSTALL_A_DIR=$(INSTALL) -d
-
-# Set this to the name of the program to create RPMs.
-# This works for Red Hat Linux 8.0:
-RPMBUILD=rpmbuild -ba
-# This works for Red Hat Linux 7.X and below:
-# RPMBUILD=rpm -ba
-
-
-# From here on, nothing should need changing unless you're
-# changing the code itself.
-
-# To change the version #, change VERSION here, sloccount.spec, and
-# sloccount.html.
-# Note to self: to redistribute, do this:
-# make distribute; su; make rpm; (test as desired);
-# rpm -e sloccount; ^D; make my_install; send to web site.
-
-
-NAME=sloccount
-VERSION=2.20
-RPM_VERSION=1
-ARCH=i386
-VERSIONEDNAME=$(NAME)-$(VERSION)
-INSTALL_DIR=$(PREFIX)/bin
-MAN_DIR=$(PREFIX)/share/man
-MAN_DIR_MAN1=$(MAN_DIR)/man1
-DOC_DIR=$(PREFIX)/share/doc/$(VERSIONEDNAME)-$(RPM_VERSION)
-POSTED_DIR=/home/dwheeler/dwheeler.com/sloccount
-
-COMPILED_EXECUTABLES= \
-   c_count$(EXE_SUFFIX) \
-   java_count$(EXE_SUFFIX) \
-   lexcount1$(EXE_SUFFIX) \
-   pascal_count$(EXE_SUFFIX) \
-   php_count$(EXE_SUFFIX) \
-   jsp_count$(EXE_SUFFIX)
-
-EXECUTABLES= \
-   ada_count \
-   asm_count \
-   awk_count \
-   break_filelist \
-   cobol_count \
-   compute_all \
-   compute_sloc_lang \
-   count_extensions \
-   count_unknown_ext \
-   csh_count \
-   exp_count \
-   fortran_count \
-   generic_count \
-   get_sloc \
-   get_sloc_details \
-   haskell_count \
-   lex_count \
-   lisp_count \
-   make_filelists \
-   makefile_count \
-   ml_count \
-   modula3_count \
-   objc_count \
-   perl_count \
-   print_sum \
-   python_count \
-   ruby_count \
-   sed_count \
-   sh_count \
-   show_filecount \
-   sloccount \
-   sql_count \
-   tcl_count \
-   $(COMPILED_EXECUTABLES)
-
-MANPAGES=sloccount.1.gz
-
-MYDOCS=sloccount.html README TODO ChangeLog
-
-
-all: $(COMPILED_EXECUTABLES)
-
-lexcount1$(EXE_SUFFIX): lexcount1.c
-	$(CC) lexcount1.c -o lexcount1$(EXE_SUFFIX)
-
-c_count$(EXE_SUFFIX): c_count.c
-	$(CC) c_count.c -o c_count$(EXE_SUFFIX)
-
-php_count$(EXE_SUFFIX): php_count.c
-	$(CC) php_count.c -o php_count$(EXE_SUFFIX)
-
-pascal_count.c: pascal_count.l driver.c driver.h
-	flex -Cfe -t pascal_count.l > pascal_count.c
-
-pascal_count$(EXE_SUFFIX): pascal_count.c
-	$(CC) pascal_count.c -o pascal_count$(EXE_SUFFIX)
-
-jsp_count.c: jsp_count.l driver.c driver.h
-	flex -Cfe -t jsp_count.l > jsp_count.c
-
-jsp_count$(EXE_SUFFIX): jsp_count.c
-	$(CC) jsp_count.c -o jsp_count$(EXE_SUFFIX)
-
-sloccount.1.gz: sloccount.1
-	gzip -c sloccount.1 > sloccount.1.gz
-
-# Currently "java_count" is the same as "c_count":
-java_count$(EXE_SUFFIX): c_count$(EXE_SUFFIX)
-	cp -p c_count$(EXE_SUFFIX) java_count$(EXE_SUFFIX)
-
-# This is USC's code counter, not built by default:
-c_lines: C_LINES.C
-	$(CC) C_LINES.C -o c_lines$(EXE_SUFFIX)
-
-
-install_programs: all
-	$(INSTALL) $(EXECUTABLES) $(INSTALL_DIR)
-
-uninstall_programs:
-	cd $(INSTALL_DIR) && rm -f $(EXECUTABLES)
-
-install_man:
-	$(INSTALL_A_DIR) $(MAN_DIR_MAN1)
-	$(INSTALL) $(MANPAGES) $(MAN_DIR_MAN1)
-
-uninstall_man:
-	cd $(MAN_DIR_MAN1) && rm -f $(MANPAGES)
-
-install_docs: install_man
-	$(INSTALL_A_DIR) $(DOC_DIR)
-	$(INSTALL) $(MYDOCS) $(DOC_DIR)
-
-uninstall_docs:
-	cd $(DOC_DIR) && rm -f $(MYDOCS) && rmdir $(DOC_DIR)
-
-
-install: install_programs install_man install_docs
-
-uninstall: uninstall_programs uninstall_docs uninstall_man
-
-
-clean:
-	-rm -f $(COMPILED_EXECUTABLES) core sloccount.1.gz
-
-phptest: php_count
-	./php_count *.php
-	./php_count /usr/share/php/*.php
-	./php_count /usr/share/php/*/*.php
-
-# "make distribute" creates the tarball.
-
-
-distribute: clean $(MANPAGES)
-	rm -f sloccount-$(VERSION).tgz
-	rm -f sloccount-$(VERSION).tar.gz
-	mkdir 9temp
-	cp -pr [A-Za-z]* 9temp
-	mv 9temp $(VERSIONEDNAME)
-	rm -f $(VERSIONEDNAME)/*.tgz
-	rm -f $(VERSIONEDNAME)/*.tar.gz
-	rm -f $(VERSIONEDNAME)/*.rpm
-#	rm -f $(VERSIONEDNAME)/*.1.gz
-	rm -f $(VERSIONEDNAME)/C_LINES.C
-	rm -f $(VERSIONEDNAME)/java_lines.c
-	rm -f $(VERSIONEDNAME)/c_lines
-	tar -cvf - $(VERSIONEDNAME)/* | \
-		gzip --best > $(VERSIONEDNAME).tar.gz
-	chown --reference=README $(VERSIONEDNAME).tar.gz
-	chmod a+rX *
-	rm -fr $(VERSIONEDNAME)
-
-my_install: distribute
-	chmod a+rX *
-	cp -p sloccount-$(VERSION).tar.gz $(POSTED_DIR)
-	cp -p sloccount.html $(POSTED_DIR)
-	cp -p ChangeLog $(POSTED_DIR)
-	cp -p TODO $(POSTED_DIR)
-	cp -p /usr/src/redhat/RPMS/$(ARCH)/$(VERSIONEDNAME)-$(RPM_VERSION)*.rpm $(POSTED_DIR)
-	cp -p /usr/src/redhat/SRPMS/$(VERSIONEDNAME)-$(RPM_VERSION)*.src.rpm $(POSTED_DIR)
-	
-
-rpm: distribute
-	cp $(VERSIONEDNAME).tar.gz /usr/src/redhat/SOURCES
-	cp sloccount.spec /usr/src/redhat/SPECS
-	cd /usr/src/redhat/SPECS
-	# Uninstall current sloccount if any; ignore errors if not installed.
-	-rpm -e sloccount
-	$(RPMBUILD) sloccount.spec
-	chmod a+r /usr/src/redhat/RPMS/$(ARCH)/$(VERSIONEDNAME)-$(RPM_VERSION)*.rpm
-	chmod a+r /usr/src/redhat/SRPMS/$(VERSIONEDNAME)-$(RPM_VERSION)*.src.rpm
-	rpm -ivh /usr/src/redhat/RPMS/$(ARCH)/$(VERSIONEDNAME)-$(RPM_VERSION)*.rpm
-	echo "Use rpm -e $(NAME) to remove the package"
-
-
