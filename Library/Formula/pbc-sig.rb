require 'formula'

class PbcSig < Formula
  homepage 'http://crypto.stanford.edu/pbc/sig/'
  url 'http://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz'
  sha1 '718d86bca56c5e11ed87967770cb0d27533cd751'

  depends_on 'pbc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
