require 'formula'

class Zlib < Formula
  homepage 'http://www.zlib.net/'
  url 'http://zlib.net/zlib-1.2.8.tar.gz'
  mirror 'https://downloads.sourceforge.net/project/libpng/zlib/1.2.8/zlib-1.2.8.tar.gz'
  sha1 'a4d316c404ff54ca545ea71a27af7dbc29817088'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/dupes"
    cellar :any
    sha1 "8111b1453b1ac71c0249f2e3abe2ce16372509af" => :yosemite
    sha1 "4902071981b276d201681dc4321534f94d3f32c5" => :mavericks
    sha1 "e431acef3aa6c11d9ae8a68c29e37d3bd7400492" => :mountain_lion
  end

  keg_only :provided_by_osx

  option :universal

  # configure script fails to detect the right compiler when "cc" is
  # clang, not gcc. zlib mantainers have been notified of the issue.
  # See: https://github.com/Homebrew/homebrew-dupes/pull/228
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index b77a8a8..54f33f7 100755
--- a/configure
+++ b/configure
@@ -159,6 +159,7 @@ case "$cc" in
 esac
 case `$cc -v 2>&1` in
   *gcc*) gcc=1 ;;
+  *clang*) gcc=1 ;;
 esac
 
 show $cc -c $test.c
