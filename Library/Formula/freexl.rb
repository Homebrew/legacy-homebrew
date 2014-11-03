require 'formula'

class Freexl < Formula
  homepage 'https://www.gaia-gis.it/fossil/freexl/index'
  url 'http://www.gaia-gis.it/gaia-sins/freexl-1.0.0g.tar.gz'
  sha1 '2a5b1d3ebbaf217c7bda15b5b3f1e0222c6c1502'

  bottle do
    cellar :any
    revision 1
    sha1 "0158f6a76dcf1fd8ab569f2689a745fefc61fc90" => :yosemite
    sha1 "7a90c3a51e61ebbc1a5f46eae6483bbb3dc4517f" => :mavericks
    sha1 "effe1c8fda7ae09b761e3388962cb59e676459b5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
