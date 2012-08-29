require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  url 'http://www.cipherdyne.org/fwknop/download/fwknop-2.0.1.tar.gz'
  sha1 '71b2de97c80daf4f7db3aa0ca204731c8f11f3e2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop", "--version"
  end
end
