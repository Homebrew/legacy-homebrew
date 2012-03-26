require 'formula'

class Cryptopp < Formula
  homepage 'http://www.cryptopp.com/'
  url 'http://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.1/cryptopp561.zip'
  sha1 '31dbb456c21f50865218c57b7eaf4c955a222ba1'
  version '5.6.1'

  def install
    # patches welcome to re-enable this on configurations that support it
    ENV.append 'CXXFLAGS', '-DCRYPTOPP_DISABLE_ASM'

    system "make", "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cxxflags}"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end
