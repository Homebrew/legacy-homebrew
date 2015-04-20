require 'formula'

class PbcSig < Formula
  homepage 'http://crypto.stanford.edu/pbc/sig/'
  url 'http://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz'
  sha256 '7a343bf342e709ea41beb7090c78078a9e57b833454c695f7bcad2475de9c4bb'

  depends_on 'pbc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
