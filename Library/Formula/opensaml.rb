require 'formula'

class Opensaml < Formula
  url 'http://shibboleth.internet2.edu/downloads/opensaml/cpp/2.3/opensaml-2.3.tar.gz'
  homepage 'https://spaces.internet2.edu/display/OpenSAML/'
  md5 '9695d40cb28519c2cde8211cd1c3dc69'

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
