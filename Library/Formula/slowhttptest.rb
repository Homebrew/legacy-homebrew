require 'formula'

class Slowhttptest < Formula
  homepage 'http://code.google.com/p/slowhttptest/'
  url 'http://slowhttptest.googlecode.com/files/slowhttptest-1.5.tar.gz'
  sha1 'be3f125e1358150ec9c44e35438c79040822a6ef'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/slowhttptest", *%w{-u http://google.com -p 1 -r 1 -l 1 -i 1}
  end
end
