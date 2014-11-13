require 'formula'

class Jansson < Formula
  homepage 'http://www.digip.org/jansson/'
  url 'http://www.digip.org/jansson/releases/jansson-2.6.tar.gz'
  sha1 '70ff0bf10db63850e5d26327d1e9fd8a58d608e4'

  bottle do
    cellar :any
    sha1 "7654f62473150c646f5c23ec8d1c8cb68a98626a" => :yosemite
    sha1 "c1a5dbc0eab03aab1126541626b157945f02edff" => :mavericks
    sha1 "c603486520d793158953c47c2ed2841462812fb0" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
