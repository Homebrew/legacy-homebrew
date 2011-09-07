require 'formula'

class Cryptopp < Formula
  url 'http://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.1/cryptopp561.zip'
  homepage 'http://www.cryptopp.com/'
  sha1 '31dbb456c21f50865218c57b7eaf4c955a222ba1'
  version '5.6.1'

  def install
    system "make"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end
