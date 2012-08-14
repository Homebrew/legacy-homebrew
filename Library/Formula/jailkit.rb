require 'formula'

class Jailkit < Formula
  homepage 'http://olivier.sessink.nl/jailkit/'
  url 'http://olivier.sessink.nl/jailkit/jailkit-2.15.tar.bz2'
  sha1 '85c78de913ec6d1edc6c0d1f2b6a2a4335b7a5a3'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
  end
end
