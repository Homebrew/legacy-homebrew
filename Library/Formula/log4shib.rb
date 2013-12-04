require 'formula'

class Log4shib < Formula
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib'
  url 'http://shibboleth.net/downloads/log4shib/1.0.8/log4shib-1.0.8.tar.gz'
  sha1 '407c70935917a59034acba4e63803d32465af641'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
