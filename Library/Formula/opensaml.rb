class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "http://shibboleth.net/downloads/c++-opensaml/2.5.3/opensaml-2.5.3.tar.gz"
  sha256 "1ed6a241b2021def6a1af57d3087b697c98b38842e9195e1f3fae194d55c13fb"

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
