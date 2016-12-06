require 'formula'

class Libfplll < Formula
  homepage 'http://xpujol.net/fplll/'
  url 'http://xpujol.net/fplll/libfplll-4.0.1.tar.gz'
  sha1 'ce18f0f0113969172b77b790fb370fcd2d304a32'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    prefix.install "src/dim55_in"
  end

  def test
    system "#{bin}/fplll < #{prefix}/dim55_in"
  end
end
