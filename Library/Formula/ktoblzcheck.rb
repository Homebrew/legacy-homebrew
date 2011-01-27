require 'formula'

class Ktoblzcheck <Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.28.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 'c0d4eea78f30e9bef4c5770c4773cde0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
