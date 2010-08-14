require 'formula'

class Patchutils <Formula
  url 'http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.1.tar.bz2'
  homepage 'http://cyberelk.net/tim/software/patchutils/'
  md5 '3fd9bca58a429fbbb1c2126f1b72aa23'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
