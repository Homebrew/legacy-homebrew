require 'formula'

class RBashCompletion < Formula
  # This is the same script that Debian packages use.
  url 'http://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R', :using => :curl
  version 'r28'
  sha1 'af734b8624b33f2245bf88d6782bea0dc5d829a4'
end

class R < Formula
  homepage 'http://www.r-project.org'
  url 'http://cran.r-project.org/src/base/R-2/R-2.15.2.tar.gz'
  sha1 'c80da687d66ee88d1e34fc1ae5c1bd525f9513dd'

  head 'https://svn.r-project.org/R/trunk'

  option 'with-valgrind', 'Compile an unoptimized build with support for the Valgrind debugger'

  depends_on 'readline'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on :x11

  depends_on 'valgrind' if build.include? 'with-valgrind'

  def patches
    # Fix detection of Objective-C++ in configure. Reported upstream:
    #   https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=15107
    DATA
  end if MacOS.version >= :mountain_lion

  def install
    ENV.Og if build.include? 'with-valgrind'
    ENV.fortran

    args = [
      "--prefix=#{prefix}",
      "--with-aqua",
      "--enable-R-framework",
      "--with-lapack"
    ]
    args << '--with-valgrind-instrumentation=2' if build.include? 'with-valgrind'

    # Pull down recommended packages if building from HEAD.
    system './tools/rsync-recommended' if build.head?

    system "./configure", *args
    system "make"
    ENV.j1 # Serialized installs, please
    system "make install"

    # Link binaries and manpages from the Framework
    # into the normal locations
    bin.mkpath
    man1.mkpath

    ln_s prefix+"R.framework/Resources/bin/R", bin
    ln_s prefix+"R.framework/Resources/bin/Rscript", bin
    ln_s prefix+"R.framework/Resources/man1/R.1", man1
    ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1

    bash_dir = prefix + 'etc/bash_completion.d'
    bash_dir.mkpath
    RBashCompletion.new.brew { bash_dir.install 'R' }
  end

  def caveats; <<-EOS.undent
    R.framework was installed to:
      #{opt_prefix}/R.framework

    To use this Framework with IDEs such as RStudio, it must be linked
    to the standard OS X location:
      sudo ln -s "#{opt_prefix}/R.framework" /Library/Frameworks

    To enable rJava support, run the following command:
      R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
    EOS
  end
end

__END__

Patch configure so that Objective-C++ tests pass on OS X 10.8.x. The problem is
that every test uses the header file `objc/Object.h` to define Objective-C
objects and this header is a no-op include on 10.8 unless the `__OBJC2__`
preprocessor variable is undefined.

Upstream bug:

  https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=15107

diff --git a/configure b/configure
index 5bae281..baf4f47 100755
--- a/configure
+++ b/configure
@@ -8328,6 +8328,7 @@ $as_echo_n "checking whether ${OBJCXX} can compile ObjC++... " >&6; }
 ## we don't use AC_LANG_xx because ObjC++ is not defined as a language (yet)
 ## (the test program is from the gcc test suite)
 cat << \EOF > conftest.mm
+#undef __OBJC2__
 #include <objc/Object.h>
 #include <iostream>
 
@@ -8368,6 +8369,7 @@ $as_echo_n "checking whether ${CXX} can compile ObjC++... " >&6; }
 ## we don't use AC_LANG_xx because ObjC++ is not defined as a language (yet)
 ## (the test program is from the gcc test suite)
 cat << \EOF > conftest.mm
+#undef __OBJC2__
 #include <objc/Object.h>
 #include <iostream>
 
@@ -8403,6 +8405,7 @@ $as_echo_n "checking whether ${OBJC} can compile ObjC++... " >&6; }
 ## we don't use AC_LANG_xx because ObjC++ is not defined as a language (yet)
 ## (the test program is from the gcc test suite)
 cat << \EOF > conftest.mm
+#undef __OBJC2__
 #include <objc/Object.h>
 #include <iostream>
 
@@ -24389,7 +24392,7 @@ else
       cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
-
+#undef __OBJC2__
 #include <objc/Object.h>
 
 #ifdef F77_DUMMY_MAIN
