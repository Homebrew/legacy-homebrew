require 'formula'

class Ppl <Formula
  url 'http://www.cs.unipr.it/ppl/Download/ftp/releases/0.10.2/ppl-0.10.2.tar.bz2'
  homepage 'http://www.cs.unipr.it/ppl/'
  md5 '5667111f53150618b0fa522ffc53fc3e'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=sspeed"
    system "make install"
  end
end
