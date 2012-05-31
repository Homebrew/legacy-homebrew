require 'formula'

class Vbindiff < Formula
  url 'http://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz'
  version '3.0_beta4'
  md5 'dbda80ef580e1a0975ef50b9aaa5210e'
  homepage 'http://www.cjmweb.net/vbindiff/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
