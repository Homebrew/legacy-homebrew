require 'formula'

class Nmap < Formula
  homepage 'http://nmap.org/5/'
  url 'http://nmap.org/dist/nmap-5.51.tar.bz2'
  md5 '0b80d2cb92ace5ebba8095a4c2850275'

  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.leopard?

  fails_with :llvm do
    build 2334
  end

  # The configure script has a C file to test for some functionality that uses
  # void main(void). This does not compile with clang but does compile with
  # GCC/gcc-llvm. This small patch fixes the issues so that the project will
  # compile without issues with clang as well. See:
  # https://github.com/mxcl/homebrew/issues/10300
  def patches
    DATA
  end

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}", "--without-zenmap"]

    if MacOS.leopard?
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end
end

__END__
--- nmap-5.51/nbase/configure	2012-02-18 02:40:16.000000000 -0700
+++ nmap-5.51/nbase/configure.old	2012-02-18 02:40:01.000000000 -0700
@@ -4509,7 +4509,7 @@
 #include <sys/socket.h>
 #endif

-void main(void) {
+int main(void) {
     struct addrinfo hints, *ai;
     int error;

@@ -4641,7 +4641,7 @@
 #include <netinet/in.h>
 #endif

-void main(void) {
+int main(void) {
     struct sockaddr_in sa;
     char hbuf[256];
     int error;
