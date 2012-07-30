require 'formula'

class Blast < Formula
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  url 'ftp://ftp.ncbi.nih.gov/blast/executables/blast+/2.2.25/ncbi-blast-2.2.25+-src.tar.gz'
  version '2.2.25'
  md5 '01256b808e3af49a5087945b6a8c8293'

  fails_with :clang do
    build 421
  end

  def options
    [['--with-dll', "Create dynamic binaries instead of static"]]
  end

  # fixes to 2.2.25 acknowledged upstream by Aaron U. per email
  # inform configure about -Os
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-dll" if ARGV.include? '--with-dll'

    cd 'c++' do
      system "./configure", *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--with-dll' will create dynamic binaries instead of
    static. NCBI Blast static binaries are approximately 28-times larger
    than dynamic binaries.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.
    EOS
  end
end

__END__
---
 c++/src/build-system/configure |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/c++/src/build-system/configure b/c++/src/build-system/configure
index 2f467a2..a2d14c7 100755
--- a/c++/src/build-system/configure
+++ b/c++/src/build-system/configure
@@ -8538,29 +8538,29 @@ fi
 if test "$compiler" != "MSVC" ; then
    if test "$with_debug" = "no" ; then
       with_optimization=${with_optimization:="yes"}
-      CFLAGS=`  echo " $CFLAGS"   | sed 's/[ 	]-g[0-9]*//g'`
-      CXXFLAGS=`echo " $CXXFLAGS" | sed 's/[ 	]-g[0-9]*//g'`
-      LDFLAGS=` echo " $LDFLAGS"  | sed 's/[ 	]-g[0-9]*//g'`
+      CFLAGS=`  echo " $CFLAGS"   | sed 's/[ 	]-g[0-9s]*//g'`
+      CXXFLAGS=`echo " $CXXFLAGS" | sed 's/[ 	]-g[0-9s]*//g'`
+      LDFLAGS=` echo " $LDFLAGS"  | sed 's/[ 	]-g[0-9s]*//g'`
       CPPFLAGS="-DNDEBUG $CPPFLAGS"
    else
       with_optimization=${with_optimization:="no"}
-      if echo " $CFLAGS"   |grep -v >/dev/null '[ 	]-g[0-9]*' ; then
+      if echo " $CFLAGS"   |grep -v >/dev/null '[ 	]-g[0-9s]*' ; then
          CFLAGS="$CFLAGS -g"     ; fi
-      if echo " $CXXFLAGS" |grep -v >/dev/null '[ 	]-g[0-9]*' ; then
+      if echo " $CXXFLAGS" |grep -v >/dev/null '[ 	]-g[0-9s]*' ; then
          CXXFLAGS="$CXXFLAGS -g" ; fi
       if test "${with_tcheck=no}" = "no" ; then
          CPPFLAGS="-D_DEBUG $CPPFLAGS"
       else
          CPPFLAGS="-DNDEBUG $CPPFLAGS"
       fi
-      if echo " $LDFLAGS"  |grep -v >/dev/null '[ 	]-g[0-9]*' ;
+      if echo " $LDFLAGS"  |grep -v >/dev/null '[ 	]-g[0-9s]*' ;
          then LDFLAGS="$LDFLAGS -g" ; fi
       STRIP="@:"
    fi

-   NOPT_CFLAGS=`  echo " $CFLAGS"    | sed 's/[ 	]-x*O[0-9]*//g'`
-   NOPT_CXXFLAGS=`echo " $CXXFLAGS"  | sed 's/[ 	]-x*O[0-9]*//g'`
-   NOPT_LDFLAGS=` echo " $LDFLAGS"   | sed 's/[ 	]-x*O[0-9]*//g'`
+   NOPT_CFLAGS=`  echo " $CFLAGS"    | sed 's/[ 	]-x*O[0-9s]*//g'`
+   NOPT_CXXFLAGS=`echo " $CXXFLAGS"  | sed 's/[ 	]-x*O[0-9s]*//g'`
+   NOPT_LDFLAGS=` echo " $LDFLAGS"   | sed 's/[ 	]-x*O[0-9s]*//g'`
    if test "${with_tcheck-no}" != "no"; then
       # Suppress warnings when building with ICC.
       NOPT_CFLAGS="$NOPT_CFLAGS -O0"
@@ -8575,11 +8575,11 @@ if test "$compiler" != "MSVC" ; then
       FAST_CXXFLAGS="$CXXFLAGS"
       FAST_LDFLAGS="$LDFLAGS"
    else
-      if echo " $CFLAGS"   |grep -v >/dev/null '[ 	]-x*O[0-9]*' ; then
+      if echo " $CFLAGS"   |grep -v >/dev/null '[ 	]-x*O[0-9s]*' ; then
          CFLAGS="$CFLAGS -O" ; fi
-      if echo " $CXXFLAGS" |grep -v >/dev/null '[ 	]-x*O[0-9]*' ; then
+      if echo " $CXXFLAGS" |grep -v >/dev/null '[ 	]-x*O[0-9s]*' ; then
          CXXFLAGS="$CXXFLAGS -O" ; fi
-      if echo " $LDFLAGS"  |grep -v >/dev/null '[ 	]-x*O[0-9]*' ; then
+      if echo " $LDFLAGS"  |grep -v >/dev/null '[ 	]-x*O[0-9s]*' ; then
          LDFLAGS="$LDFLAGS -O" ; fi
       FAST_CFLAGS="$NOPT_CFLAGS $FAST_CFLAGS"
       FAST_CXXFLAGS="$NOPT_CXXFLAGS $FAST_CXXFLAGS"
--
1.7.9.2

