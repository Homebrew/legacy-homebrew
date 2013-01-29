require 'formula'

class Base64 < Formula
  homepage 'http://www.fourmilab.ch/webtools/base64/'
  url 'http://www.fourmilab.ch/webtools/base64/base64-1.5.tar.gz'
  sha1 '25b5ae71c2818c7a489065ca1637806cd5109524'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "base64"
  end
end
