require 'formula'

class Primesieve < Formula
  url 'http://primesieve.googlecode.com/files/primesieve-3.5-src.zip'
  homepage 'http://code.google.com/p/primesieve'
  sha1 '044388377a976529a2fd51006d9f7b0ae02bd868'

  def install
    system "make"
    system "make lib SHARED=yes"
    system "make PREFIX=#{prefix} install"
  end

  def test
    system "#{bin}/primesieve -v"
  end
end
