require 'formula'

class Ktoblzcheck < Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.33.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 'e9f62a9a64ee51ab43751eadcade0433'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
