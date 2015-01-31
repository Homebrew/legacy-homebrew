class Slowhttptest < Formula
  homepage "https://code.google.com/p/slowhttptest/"
  url "https://slowhttptest.googlecode.com/files/slowhttptest-1.6.tar.gz"
  sha1 "f5a64365b987083015ac98f6c20746021176292e"
  revision 1

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", *%w{-u http://google.com -p 1 -r 1 -l 1 -i 1}
  end
end
