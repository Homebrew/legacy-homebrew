class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/2.5.3/xmltooling-1.5.3.tar.gz"
  sha256 "90e453deb738574b04f1f1aa08ed7cc9d8746bcbf93eb59f401a6e38f2ec9574"

  bottle do
    cellar :any
    sha256 "79189320ce4dfc9647e951d3382e27b107f5de4d7d132d221ee8047f45af93f3" => :el_capitan
    sha256 "c2cc10cc3bc69a9aa744c8ae9383f7ccb4bb9ea2941c558be6ee3fe069075c85" => :yosemite
    sha256 "bd4c05a80dc82e1fac3b4fd68f6a518c45cd19d62f9a682642f23b333302d856" => :mavericks
  end

  option "with-openssl", "Build with OpenSSL instead of Secure Transport"

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "curl" => "with-openssl" if build.with? "openssl"

  def install
    ENV.O2 # Os breaks the build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
