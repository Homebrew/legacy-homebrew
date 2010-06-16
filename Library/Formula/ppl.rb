require 'formula'

class Ppl <Formula
  url 'http://www.cs.unipr.it/ppl/Download/ftp/releases/0.10.2/ppl-0.10.2.tar.bz2'
  head 'http://www.cs.unipr.it/ppl/Download/ftp/snapshots/ppl-0.11pre24.tar.bz2'
  homepage 'http://www.cs.unipr.it/ppl/'

  if ARGV.include? "--HEAD"
    md5 '14f4d5297a161f9ba22c33945fc61a27'
  else
    md5 '5667111f53150618b0fa522ffc53fc3e'
  end

  depends_on 'gmp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=sspeed"
    system "make install"
  end
end
