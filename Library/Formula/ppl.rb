require 'formula'

class Ppl <Formula
  url 'http://www.cs.unipr.it/ppl/Download/ftp/releases/0.10.2/ppl-0.10.2.tar.bz2'
  homepage 'http://www.cs.unipr.it/ppl/'
  md5 '5667111f53150618b0fa522ffc53fc3e'

  depends_on 'gmp'

  def install
    configure_args = [
		"--prefix=#{prefix}",
		"--disable-debug",
		"--disable-dependency-tracking",
		"--enable-optimization=sspeed",
    ]

    system "./configure", *args
    system "make install"
  end
end
