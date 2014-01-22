require 'formula'

class RegexOpt < Formula
  homepage 'http://bisqwit.iki.fi/source/regexopt.html'
  url 'http://bisqwit.iki.fi/src/arch/regex-opt-1.2.3.tar.gz'
  sha1 'a3b58af5a173a9b77ede7d0cb01831ae7a315b38'

  depends_on 'apple-gcc42' if MacOS.version >= :mountain_lion

  def install
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install 'regex-opt'
  end

  fails_with :clang do
    cause <<-EOS.undent
      regexp-opt uses GCC extensions and must be built with gcc, not clang.
      EOS
  end

  def test
    system "#{bin}/regex-opt"
  end
end
