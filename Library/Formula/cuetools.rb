require 'formula'

class Cuetools < Formula
  homepage 'http://developer.berlios.de/projects/cuetools/'
  url 'http://download.berlios.de/cuetools/cuetools-1.3.1.tar.gz'
  sha1 'ad760cdf76d6548471144302f88bf0a66f1d5ea2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
