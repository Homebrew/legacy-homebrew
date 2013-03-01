require 'formula'

class PbcSig < Formula
  homepage 'http://crypto.stanford.edu/pbc/sig/'
  url 'http://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.7.tar.gz'
  sha1 'f15e4b721f95d073dfbe1a4687c490b82f7ac176'

  depends_on 'pbc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
