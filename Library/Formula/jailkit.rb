require 'formula'

class Jailkit < Formula
  url 'http://olivier.sessink.nl/jailkit/jailkit-2.14.tar.bz2'
  homepage 'http://olivier.sessink.nl/jailkit/'
  md5 '8bf28ca05b32a6ef074e0692561db027'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
  end
end
