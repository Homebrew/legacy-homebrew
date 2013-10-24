require 'formula'

class Log4shib < Formula
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib'
  url 'http://shibboleth.net/downloads/log4shib/1.0.6/log4shib-1.0.6.tar.gz'
  sha256 '060f472a085e34658f4eb19c2be56010adfcf33cf138071f8e7c953aa278d567'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
