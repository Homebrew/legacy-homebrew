require 'formula'

class Freexl < Formula
  homepage 'https://www.gaia-gis.it/fossil/freexl/index'
  url 'http://www.gaia-gis.it/gaia-sins/freexl-1.0.0g.tar.gz'
  sha1 '2a5b1d3ebbaf217c7bda15b5b3f1e0222c6c1502'

  bottle do
    cellar :any
    sha1 "d1729348001c834a696413d136fb5d3878c1e31d" => :mavericks
    sha1 "7bf3a241bf10d344a30e17f6d08f95ab96ec85dc" => :mountain_lion
    sha1 "9040a8b129717d8e2b76ddd616ce9d04b8baf9dc" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
