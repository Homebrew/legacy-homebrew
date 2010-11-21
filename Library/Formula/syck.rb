require 'formula'

class Syck <Formula
  url 'http://cloud.github.com/downloads/indeyets/syck/syck-0.70.tar.gz'
  homepage 'https://wiki.github.com/indeyets/syck/'
  md5 '198f925b4ed7fe04a182c35014498634'

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
