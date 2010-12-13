require 'formula'

class Hydra <Formula
  url 'http://freeworld.thc.org/releases/hydra-5.7-src.tar.gz'
  homepage 'http://freeworld.thc.org/thc-hydra/'
  md5 'a8ad06ed726208800ca9a3c09aaf9cf7'

  def install
    system "./configure", "--disable-xhydra", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    bin.mkpath
    system "make install"
  end
end
