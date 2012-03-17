require 'formula'

class Ktoblzcheck < Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.37.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 '93b540b5478bfb1b078613cbf1cc2446'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
