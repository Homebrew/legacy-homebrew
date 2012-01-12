require 'formula'

class PbcSig < Formula
  url 'http://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.7.tar.gz'
  homepage 'http://crypto.stanford.edu/pbc/sig/'
  md5 'a89b347c9a240b6f789848a12e0b6229'

  depends_on 'pbc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
