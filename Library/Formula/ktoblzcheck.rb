require 'formula'

class Ktoblzcheck < Formula
  homepage 'http://ktoblzcheck.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.37.tar.gz'
  md5 '93b540b5478bfb1b078613cbf1cc2446'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
