require 'brewkit'

class Libidn <Formula
  @url='http://ftp.gnu.org/gnu/libidn/libidn-1.9.tar.gz'
  @homepage='http://www.gnu.org/software/libidn/'
  @md5='f4d794639564256a367566302611224e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-csharp"
    system "make install"
  end
end
