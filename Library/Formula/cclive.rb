require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.14.tar.xz'
  sha1 '2e4dafd7266095610a2154117a15682e5987ed89'
  
  devel do
    url 'http://downloads.sourceforge.net/project/cclive/0.9/cclive-0.9.2.tar.xz'
    sha1 '4c0671dd7c47dde5843b24dc5b9c59e93fe17b23'
  end
  
  head 'https://github.com/legatvs/cclive.git', :branch => 'next'
  
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'automake' => :build if build.head?
  depends_on 'autoconf' => :build if build.head?
  depends_on 'asciidoc' => :build if build.head?
  depends_on 'libtool' => :build if build.head?
  depends_on 'glibmm' => :build if build.head?
  depends_on 'boost149'
  depends_on 'quvi'
  depends_on 'pcre'
  
  def patches
    DATA
  end if build.head?
  
  def install
    if build.head?
      File.open('VERSION', 'w') {|f| f.write 'v' + devel.version}
      ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"
      system "./bootstrap.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  
  test do
    system "cclive", "-v"
  end
end

__END__

diff --git a/configure.ac b/configure.ac
index c9e6236..5f05f3e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,7 @@ AC_USE_SYSTEM_EXTENSIONS
 AC_DEFINE_UNQUOTED([CANONICAL_TARGET], "$target",
   [Define to canonical target])
 
-AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip tar-ustar])
+AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip tar-ustar subdir-objects])
 AM_SILENT_RULES([yes])
 
 # GNU Automake 1.12 requires this macro. Earlier versions do not

diff --git a/bootstrap.sh b/bootstrap.sh
index 3bf84d6..5646fbf 100755
--- a/bootstrap.sh
+++ b/bootstrap.sh
@@ -60,4 +60,4 @@ do
 done
 
 echo "Generate configuration files..."
-autoreconf -if && echo "You can now run 'configure'"
+autoreconf -ifv && echo "You can now run 'configure'"

diff --git a/src/cc/error.h b/src/cc/error.h
index 2f2b559..6740618 100644
--- a/src/cc/error.h
+++ b/src/cc/error.h
@@ -39,7 +39,7 @@ namespace error
 static inline std::string strerror(const int ec)
 {
   char buf[256];
-  return strerror_r(ec, buf, sizeof(buf));
+  return (char*)strerror_r(ec, buf, sizeof(buf));
 }
