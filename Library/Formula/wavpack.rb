require 'formula'

class Wavpack < Formula
  homepage 'http://www.wavpack.com/'
  url 'http://www.wavpack.com/wavpack-4.70.0.tar.bz2'
  sha1 '7bf2022c988c19067196ee1fdadc919baacf46d1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
