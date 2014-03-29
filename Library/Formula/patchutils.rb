require 'formula'

class Patchutils < Formula
  homepage 'http://cyberelk.net/tim/software/patchutils/'
  url 'http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.3.tar.xz'
  sha1 '89d3f8a454bacede1b9a112b3a13701ed876fcc1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
