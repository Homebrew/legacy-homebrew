require 'formula'

class Libxslt < Formula
  homepage 'http://xmlsoft.org/XSLT/'
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxslt-1.1.28.tar.gz'
  sha1 '4df177de629b2653db322bfb891afa3c0d1fa221'

  bottle do
    revision 1
    sha1 "b2fbd32e69e1787d4ea792ee2c51f81466b26f20" => :yosemite
    sha1 "3f2dee00534b0646cfdcd8064a16c970c4a01cd0" => :mavericks
    sha1 "791b272f8c0aca80af72c263f9e0f7066ce00628" => :mountain_lion
  end

  keg_only :provided_by_osx

  depends_on 'libxml2'

  head do
    url "git://git.gnome.org/libxslt"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # https://bugzilla.gnome.org/show_bug.cgi?id=743148
    patch :DATA
  end

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          ("--without-crypto" if OS.linux?),
                          "--with-libxml-prefix=#{Formula["libxml2"].prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end
end
__END__
diff --git a/autogen.sh b/autogen.sh
index 0eeadd3..5e85821 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -8,7 +8,7 @@ THEDIR=`pwd`
 cd $srcdir
 DIE=0
 
-(autoconf --version) < /dev/null > /dev/null 2>&1 || {
+(autoreconf --version) < /dev/null > /dev/null 2>&1 || {
 	echo
 	echo "You must have autoconf installed to compile libxslt."
 	echo "Download the appropriate package for your distribution,"
@@ -16,22 +16,6 @@ DIE=0
 	DIE=1
 }
 
-(libtoolize --version) < /dev/null > /dev/null 2>&1 || {
-	echo
-	echo "You must have libtool installed to compile libxslt."
-	echo "Download the appropriate package for your distribution,"
-	echo "or see http://www.gnu.org/software/libtool"
-	DIE=1
-}
-
-(automake --version) < /dev/null > /dev/null 2>&1 || {
-	echo
-	DIE=1
-	echo "You must have automake installed to compile libxslt."
-	echo "Download the appropriate package for your distribution,"
-	echo "or see http://www.gnu.org/software/automake"
-}
-
 if test "$DIE" -eq 1; then
 	exit 1
 fi
@@ -46,14 +30,7 @@ if test -z "$NOCONFIGURE" -a -z "$*"; then
 	echo "to pass any to it, please specify them on the $0 command line."
 fi
 
-echo "Running libtoolize..."
-libtoolize --copy --force
-echo "Running aclocal..."
-aclocal $ACLOCAL_FLAGS
-echo "Running automake..."
-automake --add-missing --warnings=all
-echo "Running autoconf..."
-autoconf --warnings=all
+autoreconf -v --force --install -Wall
 
 cd $THEDIR
 
