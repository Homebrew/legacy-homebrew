require 'formula'

class Httptunnel < Formula
  homepage 'http://www.nocrew.org/software/httptunnel.html'
  url 'http://www.nocrew.org/software/httptunnel/httptunnel-3.3.tar.gz'
  sha1 'e3fa5c6499cbad9202bb7a3ba8a5b6478a60a3f3'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
