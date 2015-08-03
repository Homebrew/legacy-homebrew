class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.28.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz"
  sha256 "5fc7151a57b89c03d7b825df5a0fae0a8d5f05674c0e7cf2937ecec4d54a028c"
  revision 1

  bottle do
    sha256 "6d183c0aec7ca84802c54256289d401d05b2ae153956e118df357f70f388fed9" => :yosemite
    sha256 "3f674b2296134366637b6ab6f8880c124926b768d4ce5230564d4a1265a8797d" => :mavericks
    sha256 "2530cd13170900d9f6e5cc4c9d57312cffcb0f16a20d12cc4e82ac8e5f4455d9" => :mountain_lion
  end

  keg_only :provided_by_osx

  depends_on "libxml2"

  head do
    url "https://git.gnome.org/browse/libxslt"

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
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
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
 
