require 'formula'

class Qdbm <Formula
  url 'http://qdbm.sourceforge.net/qdbm-1.8.77.tar.gz'
  homepage 'http://qdbm.sourceforge.net/'
  md5 '084e07824e231969356ec7cefac97985'

  def install
    configure_args = [
		"--prefix=#{prefix}",
		"--disable-debug",
		"--disable-dependency-tracking",
		"--mandir=#{man}",
    ]

    system "./configure", *configure_args
    system "make mac"
    system "make install-mac"
  end
end
