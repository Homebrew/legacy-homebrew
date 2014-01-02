require 'formula'

class Jailkit < Formula
  homepage 'http://olivier.sessink.nl/jailkit/'
  url 'http://olivier.sessink.nl/jailkit/jailkit-2.16.tar.bz2'
  sha1 '679fb8783c537dc0db0bc9c3f8612a2d8aba896c'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
  end
end
