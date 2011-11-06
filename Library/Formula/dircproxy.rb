require 'formula'

class Dircproxy < Formula
  url 'http://dircproxy.googlecode.com/files/dircproxy-1.1.0.tar.gz'
  homepage 'http://code.google.com/p/dircproxy/'
  sha1 'a967a542c4c6063e8f977276b68deb6692c9d150'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
