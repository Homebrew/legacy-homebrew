require 'formula'

class Fwknop < Formula
  url 'http://www.cipherdyne.org/fwknop/download/fwknop-2.0.tar.gz'
  homepage 'http://www.cipherdyne.org/fwknop/'
  md5 'b2ee477140d9e92466c9c6f267442625'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop --version"
  end
end
