require 'formula'

class RegexOpt < Formula
  homepage 'http://bisqwit.iki.fi/source/regexopt.html'
  url 'http://bisqwit.iki.fi/src/arch/regex-opt-1.2.3.tar.gz'
  sha1 'a3b58af5a173a9b77ede7d0cb01831ae7a315b38'

  def install
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install 'regex-opt'
  end

  def test
    system "#{bin}/regex-opt"
  end
end
