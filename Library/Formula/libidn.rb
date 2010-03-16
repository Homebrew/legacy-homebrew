require 'formula'

class Libidn <Formula
  url 'http://ftp.gnu.org/gnu/libidn/libidn-1.18.tar.gz'
  homepage 'http://www.gnu.org/software/libidn/'
  sha1 '0b81360368e5100d1ec5261dea58fc72ef39ab6b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-csharp"
    system "make install"
  end
end
