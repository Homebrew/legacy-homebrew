require 'formula'

class Patchutils < Formula
  homepage 'http://cyberelk.net/tim/software/patchutils/'
  url 'http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.2.tar.bz2'
  sha1 '00c9d41318240bfae93843abd442adbdc8c4b568'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
