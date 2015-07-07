require 'formula'

class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/Home'
  url 'http://shibboleth.net/downloads/c++-opensaml/2.5.3/opensaml-2.5.3.tar.gz'
  sha1 '412d0807821f7ee5d419e59fd9fd85613d64da7b'

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
