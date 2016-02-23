class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "http://freecode.com/projects/apachetop"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/apachetop/apachetop_0.12.6.orig.tar.gz"
  sha256 "850062414517055eab2440b788b503d45ebe9b290d4b2e027a5f887ad70f3f29"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f1dd6f8ac7cb973228227b4cb678ef0bb61f618c482dc8d7d3144acccfebcf5b" => :el_capitan
    sha256 "1cfb399a8548e1ac48d7cb61374e23273aa1eb289e49ba452aa2c55641fe5bae" => :yosemite
    sha256 "78aa56c9141cfc658120edfb27e795cf178067d54f66c79fc752536d8e0335ea" => :mavericks
    sha256 "d2383e14241b9af39c197462339393463ae6f8161dae508f49b0753dff846287" => :mountain_lion
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
    system "make", "install"
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
 
 
