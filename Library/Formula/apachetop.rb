require 'formula'

class Apachetop < Formula
  homepage 'http://freecode.com/projects/apachetop'
  url 'http://ftp.debian.org/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz'
  sha1 '005c9479800a418ee7febe5027478ca8cbf3c51b'

  bottle do
    cellar :any
    sha1 "5d9cac60ff10e36bcf346a7cd333c2d16eed3ecf" => :mavericks
    sha1 "a70bbfb92d902f89032f83fb1072deb0787836a4" => :mountain_lion
    sha1 "7743bd957fb2e9da0337f9674ff2d281bd4c3ff5" => :lion
  end

  # Freecode is officially static from this point forwards. Do not rely on it for up-to-date package information.
  # Upstream hasn't had activity in years, patch from MacPorts
  patch :p0, :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make install"
  end
end

__END__
--- src/resolver.h    2005-10-15 18:10:01.000000000 +0200
+++ src/resolver.h        2007-02-17 11:24:37.000000000 
0100
@@ -10,8 +10,8 @@
 class Resolver
 {
 	public:
-	Resolver::Resolver(void);
-	Resolver::~Resolver(void);
+	Resolver(void);
+	~Resolver(void);
 	int add_request(char *request, enum resolver_action act);
 
 
