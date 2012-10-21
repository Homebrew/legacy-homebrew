require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  url 'http://www.cipherdyne.org/fwknop/download/fwknop-2.0.3.tar.gz'
  sha1 '13f0e5d3762d2ebd09183581f0fb0f6329835671'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop", "--version"
  end
end
