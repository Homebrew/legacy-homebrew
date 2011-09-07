require 'formula'

class Jailkit < Formula
  url 'http://olivier.sessink.nl/jailkit/jailkit-2.11.tar.bz2'
  homepage 'http://olivier.sessink.nl/jailkit/'
  md5 '263c6b7b86cf1323d69ca26b6b9f7556'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
  end
end
