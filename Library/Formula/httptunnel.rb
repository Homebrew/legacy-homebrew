require 'formula'

class Httptunnel < Formula
  url 'http://www.nocrew.org/software/httptunnel/httptunnel-3.0.5.tar.gz'
  homepage 'http://www.nocrew.org/software/httptunnel.html'
  md5 '2a710f377c82ab4eb201458f7b9f99c5'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
