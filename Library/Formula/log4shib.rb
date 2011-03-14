require 'formula'

class Log4shib < Formula
  url 'http://shibboleth.internet2.edu/downloads/log4shib/1.0.4/log4shib-1.0.4.tar.gz'
  homepage 'https://spaces.internet2.edu/display/OpenSAML/log4shib'
  md5 '7dcec788b0b73923dde9756869edc011'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
