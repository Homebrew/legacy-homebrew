require 'formula'

class Pbc < Formula
  url 'http://crypto.stanford.edu/pbc/files/pbc-0.5.12.tar.gz'
  homepage 'http://crypto.stanford.edu/pbc/'
  md5 '4f3f017b5709fcc46b58d1ebc6b30e3f'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
