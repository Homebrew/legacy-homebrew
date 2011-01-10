require 'formula'

class Cryptopp <Formula
  url 'http://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.0/cryptopp560.zip'
  homepage 'http://www.cryptopp.com/'
  sha1 'b836783ebd72d5bc6a916620ab2b1ecec316fef1'
  version '5.6.0'

  def install
    system "make"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end
