require 'formula'

class Qdbm <Formula
  url 'http://qdbm.sourceforge.net/qdbm-1.8.77.tar.gz'
  homepage 'http://qdbm.sourceforge.net/'
  md5 '084e07824e231969356ec7cefac97985'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make mac"
    system "make install-mac"
  end
end
