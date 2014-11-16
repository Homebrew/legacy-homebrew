require 'formula'

class RegexOpt < Formula
  homepage 'http://bisqwit.iki.fi/source/regexopt.html'
  url 'http://bisqwit.iki.fi/src/arch/regex-opt-1.2.3.tar.gz'
  sha1 'a3b58af5a173a9b77ede7d0cb01831ae7a315b38'

  def install
    # regex-opt uses _Find_first() in std::bitset, which is a
    # nonstandard extension supported in libstdc++ but not libc++
    # See: http://lists.w3.org/Archives/Public/www-archive/2006Jan/0002.html
    ENV.libstdcxx if ENV.compiler == :clang

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install 'regex-opt'
  end

  test do
    system "#{bin}/regex-opt"
  end
end
