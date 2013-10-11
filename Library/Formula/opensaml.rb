require 'formula'

class Opensaml < Formula
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/Home'
  url 'http://shibboleth.net/downloads/c++-opensaml/2.5.3/opensaml-2.5.3.tar.gz'
  sha1 'da39a3ee5e6b4b0d3255bfef95601890afd80709'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'
  depends_on 'xml-tooling-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
