require 'formula'

class Httptunnel < Formula
  url 'http://www.nocrew.org/software/httptunnel/httptunnel-3.0.5.tar.gz'
  homepage 'http://www.nocrew.org/software/httptunnel.html'
  sha1 'd48a18bb7ea7eac16837b0a1f9e99aa0b8c44475'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
