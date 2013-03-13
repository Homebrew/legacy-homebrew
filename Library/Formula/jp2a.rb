require 'formula'

class Jp2a < Formula
  homepage 'http://csl.sublevel3.org/jp2a/'
  url 'http://sourceforge.net/projects/jp2a/files/jp2a/1.0.6/jp2a-1.0.6.tar.gz'
  sha1 '8d08a7f9428632c02351452067828af215afe2cf'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/jp2a", "-V"
  end
end
