require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.17/libpng-1.5.17.tar.bz2'
  sha1 '899d660104f3ef5c349c57faad10844b388f8442'

  bottle do
    cellar :any
    sha1 'ebebf384caac558174c5c2865e9ef04d733b7cc9' => :mavericks
    sha1 'b1e7c794cef2c2b36e774c6e1aae73330c0ba4e4' => :mountain_lion
    sha1 '6999a6f3541e945f263a480d454c26384e55db18' => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
