require 'formula'

class Opensaml < Formula
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/Home'
  url 'http://shibboleth.net/downloads/c++-opensaml/2.5.2/opensaml-2.5.2.tar.gz'
  sha256 '5bc3fbe5e789ad7aedfc2919413131400290466ecd2b77b1c3f3dc4c37e6fe54'

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
