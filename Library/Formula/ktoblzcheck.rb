require 'formula'

class Ktoblzcheck < Formula
  homepage 'http://ktoblzcheck.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.45.tar.gz'
  sha1 'a552012bb219ac24dcdbac977cf94c951bfe31bc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
