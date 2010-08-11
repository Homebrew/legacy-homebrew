require 'formula'

class Ddrescue <Formula
  url 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.11.tar.gz'
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  md5 '7146046bb1851351d1337bb1f5b4e903'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
