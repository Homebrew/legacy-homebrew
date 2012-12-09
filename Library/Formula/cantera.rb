require 'formula'

class Cantera < Formula
  homepage 'http://code.google.com/p/cantera/'
  url 'http://cantera.googlecode.com/files/cantera-1.8.0-beta.tar.gz'
  sha1 'c62666590c65c9a5a17c0867f0f6b6789984131f'
  head 'http://cantera.googlecode.com/svn/cantera18/trunk/'

  depends_on 'numpy' => :python
  depends_on 'graphviz'

  # fixes the Makefiles in Cantera/cxx/demos/ that have broken install commands
  def patches
    DATA
  end

  def install
    if MacOS.prefer_64_bit?
      # There is probably a better way to do this, but this seems to work for my purposes:
      ENV['CFLAGS'] += " -arch x86_64"
      ENV['CXX_OPT'] = "-arch x86_64"
      ENV['ARCHFLAGS'] = "-arch x86_64"
      # Maybe this does all that's needed?
      ENV['BITCOMPILE'] = '64'
      buildname = "x86_64-apple-darwin"
    else
      buildname = nil # let autoconf guess
    end

    # These are the Cantera settings that I want:
    ENV['DEBUG_MODE'] = 'y'
    ENV['PYTHON_PACKAGE'] = "full"
    ENV['USE_NUMPY'] = "y"
    ENV['BUILD_MATLAB_TOOLBOX'] = 'n'
    ENV['WITH_PRIME'] = 'y'
    ENV['WITH_H298MODIFY_CAPABILITY'] = 'y'
    ENV['WITH_VCSNONIDEAL'] = 'y'
    ENV['ARCHIVE'] = "libtool -static -o"
    # I'm not entirely sure that this is required,
    # but it doesn't seem to hurt and I used to need something like it:
    ENV['NUMPY_INC_DIR'] = `python -c "from numpy import get_include; print get_include()"`.strip

    # The Makefile doesn't like to run in parallel
    ENV.deparallelize

    # Put the manuals in the right place
    inreplace 'configure', 'ct_mandir=${prefix}', "ct_mandir=#{man}"

    system "./preconfig", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          (buildname ? "--build=#{buildname}" : "")
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    The license, demos, tutorials, data, etc. can be found in:
      #{opt_prefix}

    Try the following in python to find the equilibrium composition of a
    stoichiometric methane/air mixture at 1000 K and 1 atm:
    >>> import Cantera
    >>> g=Cantera.GRI30()
    >>> g.set(X='CH4:1, O2:2, N2:8', T=1000, P=Cantera.OneAtm)
    >>> g.equilibrate('TP')
    >>> g
    EOS
  end
end

__END__
diff --git a/Cantera/cxx/demos/Makefile.in b/Cantera/cxx/demos/Makefile.in
index acd0a0b..554dd54 100644
--- a/Cantera/cxx/demos/Makefile.in
+++ b/Cantera/cxx/demos/Makefile.in
@@ -19,7 +19,7 @@ test:
 
 install:
 	@INSTALL@ -d       @ct_demodir@/cxx
-	@INSTALL@ Makefile -m ug+rw,o+r @ct_demodir@/cxx
+	@INSTALL@ -m ug+rw,o+r Makefile @ct_demodir@/cxx
 	cd combustor;       @MAKE@ install
 	cd flamespeed;      @MAKE@ install
 	cd kinetics1;       @MAKE@ install
diff --git a/Cantera/cxx/demos/NASA_coeffs/Makefile.in b/Cantera/cxx/demos/NASA_coeffs/Makefile.in
index 4038fa2..4ccc46d 100644
--- a/Cantera/cxx/demos/NASA_coeffs/Makefile.in
+++ b/Cantera/cxx/demos/NASA_coeffs/Makefile.in
@@ -89,8 +89,8 @@ install:
 	@INSTALL@ -d     $(INSTALL_DIR)
 	@INSTALL@       -c -m ug+rw,o+r Makefile.install $(INSTALL_DIR)/Makefile
 	@(for ihhh in *.cpp  *blessed* ; do  \
-             @INSTALL@        $${ihhh} -m ug+rw,o+r $(INSTALL_DIR) ; \
-             echo "@INSTALL@  $${ihhh} -m ug+rw,o+r $(INSTALL_DIR)" ; \
+             @INSTALL@        -m ug+rw,o+r $${ihhh} $(INSTALL_DIR) ; \
+             echo "@INSTALL@  -m ug+rw,o+r $${ihhh} $(INSTALL_DIR)" ; \
          done )
 	 @INSTALL@        runtest  $(INSTALL_DIR) ; 
 
diff --git a/Cantera/cxx/demos/combustor/Makefile.in b/Cantera/cxx/demos/combustor/Makefile.in
index 1a46070..d603a7f 100644
--- a/Cantera/cxx/demos/combustor/Makefile.in
+++ b/Cantera/cxx/demos/combustor/Makefile.in
@@ -88,8 +88,8 @@ install:
 	@INSTALL@ -d     $(INSTALL_DIR)
 	@INSTALL@       -c -m ug+rw,o+r Makefile.install $(INSTALL_DIR)/Makefile
 	@(for ihhh in *.cpp  *blessed* ; do  \
-             @INSTALL@        $${ihhh} -m ug+rw,o+r $(INSTALL_DIR) ; \
-             echo "@INSTALL@  $${ihhh} -m ug+rw,o+r $(INSTALL_DIR)" ; \
+             @INSTALL@        -m ug+rw,o+r $${ihhh} $(INSTALL_DIR) ; \
+             echo "@INSTALL@  -m ug+rw,o+r $${ihhh} $(INSTALL_DIR)" ; \
          done )
 	 @INSTALL@        runtest  $(INSTALL_DIR) ; 
 
diff --git a/Cantera/cxx/demos/flamespeed/Makefile.in b/Cantera/cxx/demos/flamespeed/Makefile.in
index b55941e..10828a4 100644
--- a/Cantera/cxx/demos/flamespeed/Makefile.in
+++ b/Cantera/cxx/demos/flamespeed/Makefile.in
@@ -89,8 +89,8 @@ install:
 	@INSTALL@ -d     $(INSTALL_DIR)
 	@INSTALL@       -c -m ug+rw,o+r Makefile.install $(INSTALL_DIR)/Makefile
 	@(for ihhh in *.cpp  *blessed* ; do  \
-             @INSTALL@        $${ihhh} -m ug+rw,o+r $(INSTALL_DIR) ; \
-             echo "@INSTALL@  $${ihhh} -m ug+rw,o+r $(INSTALL_DIR)" ; \
+             @INSTALL@        -m ug+rw,o+r $${ihhh} $(INSTALL_DIR) ; \
+             echo "@INSTALL@  -m ug+rw,o+r $${ihhh} $(INSTALL_DIR)" ; \
          done )
 	 @INSTALL@        runtest  $(INSTALL_DIR) ; 
 
diff --git a/Cantera/cxx/demos/kinetics1/Makefile.in b/Cantera/cxx/demos/kinetics1/Makefile.in
index 336a2eb..ac5c891 100644
--- a/Cantera/cxx/demos/kinetics1/Makefile.in
+++ b/Cantera/cxx/demos/kinetics1/Makefile.in
@@ -89,8 +89,8 @@ install:
 	@INSTALL@ -d     $(INSTALL_DIR)
 	@INSTALL@       -c -m ug+rw,o+r Makefile.install $(INSTALL_DIR)/Makefile
 	@(for ihhh in *.cpp *.h  *blessed* ; do  \
-             @INSTALL@        $${ihhh} -m ug+rw,o+r $(INSTALL_DIR) ; \
-             echo "@INSTALL@  $${ihhh} -m ug+rw,o+r $(INSTALL_DIR)" ; \
+             @INSTALL@        -m ug+rw,o+r $${ihhh} $(INSTALL_DIR) ; \
+             echo "@INSTALL@  -m ug+rw,o+r $${ihhh} $(INSTALL_DIR)" ; \
          done )
 	 @INSTALL@        runtest  $(INSTALL_DIR) ; 
 
diff --git a/Cantera/cxx/demos/rankine/Makefile.in b/Cantera/cxx/demos/rankine/Makefile.in
index 05d776a..0892cdc 100644
--- a/Cantera/cxx/demos/rankine/Makefile.in
+++ b/Cantera/cxx/demos/rankine/Makefile.in
@@ -89,8 +89,8 @@ install:
 	@INSTALL@ -d     $(INSTALL_DIR)
 	@INSTALL@       -c -m ug+rw,o+r Makefile.install $(INSTALL_DIR)/Makefile
 	@(for ihhh in *.cpp  *blessed* ; do  \
-             @INSTALL@        $${ihhh} -m ug+rw,o+r $(INSTALL_DIR) ; \
-             echo "@INSTALL@  $${ihhh} -m ug+rw,o+r $(INSTALL_DIR)" ; \
+             @INSTALL@        -m ug+rw,o+r $${ihhh} $(INSTALL_DIR) ; \
+             echo "@INSTALL@  -m ug+rw,o+r $${ihhh} $(INSTALL_DIR)" ; \
          done )
 	 @INSTALL@        runtest  $(INSTALL_DIR) ;
 	
