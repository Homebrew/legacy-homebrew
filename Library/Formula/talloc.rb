require 'formula'

class Talloc < Formula
  homepage 'http://talloc.samba.org/'
  url 'http://www.samba.org/ftp/talloc/talloc-2.0.8.tar.gz'
  sha1 '5ca7710a3f95a1db873c97fcf83f92dddfd57907'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-rpath"
    system "make install"
  end
end
