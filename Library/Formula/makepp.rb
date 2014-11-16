require 'formula'

class Makepp < Formula
  homepage 'http://makepp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/makepp/2.0/makepp-2.0.tgz'
  sha1 '23995b1fc17255be6a42e5778f6027441dc44661'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
