require 'formula'

class Libtomcrypt < Formula
  homepage 'http://www.libtom.org/?page=features&newsitems=5&whatfile=crypt'

  url 'http://www.libtom.org/files/crypt-1.17.tar.bz2'
  sha1 '9c746822c84e4276e432b64964f94d1d5ddd13ad'

  head 'https://github.com/libtom/libtomcrypt.git'

  depends_on 'libtommath'

  option 'clean-stack', 'Causes any functions which store key material on the stack to clean up afterward.'

  # LibTomCrypt does not come with a math library, so a math descriptor is needed
  # to interface the public key cryptography APIs to GMP, LibTomMath, or TomsFastMath.
  # The libtomcrypt formula builds the LibTomMath math descriptor by default, but the user
  # has the option of also building the GMP descriptor.
  option 'with-gmp-desc', 'Build with the GMP math descriptor.'

  depends_on 'gmp' if build.include? 'with-gmp-desc'

  def patches
    DATA # Makefile tries to install as root:wheel
  end

  def install
    cflags = ['-DLTM_DESC']

    if build.include? 'clean-stack'
      cflags << '-DLTC_CLEAN_STACK'
    end
    if build.include? 'with-gmp-desc'
      cflags << '-DGMP_DESC'
    end

    ENV['CFLAGS'] = cflags.join(' ')
    ENV['DESTDIR'] = prefix

    system 'make install'
  end
end

__END__
diff --git a/makefile b/makefile
index 901a3ef..64e893f 100644
--- a/makefile
+++ b/makefile
@@ -83,28 +83,9 @@ ifndef DESTDIR
    DESTDIR=
 endif
 
-ifndef LIBPATH
-   LIBPATH=/usr/lib
-endif
-ifndef INCPATH
-   INCPATH=/usr/include
-endif
-ifndef DATAPATH
-   DATAPATH=/usr/share/doc/libtomcrypt/pdf
-endif
-
-#Who do we install as?
-ifdef INSTALL_USER
-USER=$(INSTALL_USER)
-else
-USER=root
-endif
-
-ifdef INSTALL_GROUP
-GROUP=$(INSTALL_GROUP)
-else
-GROUP=wheel
-endif
+LIBPATH=/lib
+INCPATH=/include
+DATAPATH=/share/doc/libtomcrypt/pdf
 
 #List of objects to compile.
 #START_INS
@@ -297,27 +278,20 @@ timing: library testprof/$(LIBTEST) $(TIMINGS)
 test: library testprof/$(LIBTEST) $(TESTS)
 	$(CC) $(LDFLAGS) $(TESTS) testprof/$(LIBTEST) $(LIBNAME) $(EXTRALIBS) -o $(TEST)
 
-#This rule installs the library and the header files. This must be run
-#as root in order to have a high enough permission to write to the correct
-#directories and to set the owner and group to root.
-ifndef NODOCS
-install: library docs
-else
 install: library
-endif
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(LIBPATH)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(INCPATH)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(DATAPATH)
-	install -g $(GROUP) -o $(USER) $(LIBNAME) $(DESTDIR)$(LIBPATH)
-	install -g $(GROUP) -o $(USER) $(HEADERS) $(DESTDIR)$(INCPATH)
+	install -d $(DESTDIR)$(LIBPATH)
+	install -d $(DESTDIR)$(INCPATH)
+	install -d $(DESTDIR)$(DATAPATH)
+	install $(LIBNAME) $(DESTDIR)$(LIBPATH)
+	install $(HEADERS) $(DESTDIR)$(INCPATH)
 ifndef NODOCS
-	install -g $(GROUP) -o $(USER) doc/crypt.pdf $(DESTDIR)$(DATAPATH)
+	install doc/crypt.pdf $(DESTDIR)$(DATAPATH)
 endif
 
 install_test: testprof/$(LIBTEST)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(LIBPATH)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(INCPATH)
-	install -g $(GROUP) -o $(USER) testprof/$(LIBTEST) $(DESTDIR)$(LIBPATH)
+	install -d $(DESTDIR)$(LIBPATH)
+	install -d $(DESTDIR)$(INCPATH)
+	install testprof/$(LIBTEST) $(DESTDIR)$(LIBPATH)
 
 profile:
 	CFLAGS="$(CFLAGS) -fprofile-generate" $(MAKE) timing EXTRALIBS="$(EXTRALIBS) -lgcov"
