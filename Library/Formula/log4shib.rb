require 'formula'

class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib'
  url 'http://shibboleth.net/downloads/log4shib/1.0.8/log4shib-1.0.8.tar.gz'
  sha1 '407c70935917a59034acba4e63803d32465af641'

  bottle do
    cellar :any
    sha1 "52020be4054b860c4fb405195a7a903c761b2653" => :yosemite
    sha1 "35ee49ecba1bbce1384adf514e8e6fa379d08efd" => :mavericks
    sha1 "54d576f964483fc65e6cfe77085820eadc522830" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
