require 'formula'

class Ktoblzcheck < Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.34.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 '49cee11021614946400b96cc5603f1a5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
