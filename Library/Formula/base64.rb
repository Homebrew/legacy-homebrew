require 'formula'

class Base64 < Formula
  url 'http://www.fourmilab.ch/webtools/base64/base64-1.5.tar.gz'
  homepage 'http://www.fourmilab.ch/webtools/base64/'
  md5 '3e6a217ba2c60372156c212dadce1275'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install "base64"
  end
end
