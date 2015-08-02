require 'formula'

class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage 'https://libspatialindex.github.io'
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha1 "08af1fefd0a30c895d7d714056c2a8f021f46eb4"

  bottle do
    cellar :any
    sha1 "ed7c92a7da78e4e7e5294ea52cd05c344094af98" => :yosemite
    sha1 "07e4fe6747d4db327fadc2e3e4f12a975ff4aaba" => :mavericks
    sha1 "2122a70a3dd9d966d8fdc7b9e0e285515356dd98" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
