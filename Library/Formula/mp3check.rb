require 'formula'

class Mp3check < Formula
  homepage 'http://code.google.com/p/mp3check/'
  url 'http://mp3check.googlecode.com/files/mp3check-0.8.7.tgz'
  sha1 '31fe95bb7949343f6ebc04fcaa2faffd2b738264'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
