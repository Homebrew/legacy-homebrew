require 'formula'

class Cryptopp < Formula
  homepage 'http://www.cryptopp.com/'
  url 'https://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.2/cryptopp562.zip'
  sha1 'ddc18ae41c2c940317cd6efe81871686846fa293'
  version '5.6.2'

  def install
    # patches welcome to re-enable this on configurations that support it
    ENV.append 'CXXFLAGS', '-DCRYPTOPP_DISABLE_ASM'

    system "make", "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cxxflags}"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end
