require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  url 'http://www.cipherdyne.org/fwknop/download/fwknop-2.0.tar.bz2'
  md5 '96de4c5a4ae75a8618ef80269c6a70ad'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop", "--version"
  end
end
