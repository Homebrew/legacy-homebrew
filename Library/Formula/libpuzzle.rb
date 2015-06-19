require 'formula'

class Libpuzzle < Formula
  desc "Library to find visually similar images"
  homepage 'http://libpuzzle.pureftpd.org/project/libpuzzle'
  url 'http://download.pureftpd.org/pub/pure-ftpd/misc/libpuzzle/releases/libpuzzle-0.11.tar.bz2'
  sha1 'a3352c67fd61eab33d5a03c214805b18723d719e'

  bottle do
    cellar :any
    revision 1
    sha1 "8b59bfe2bd8fb5c5105d9b826006e02191703278" => :yosemite
    sha1 "8ba8f68799caa46c1a47dd66552fccfbb3f74afa" => :mavericks
    sha1 "eb9791c2c0bb5429a31da0fa23a95e5df0be6f9b" => :mountain_lion
  end

  depends_on 'gd'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
