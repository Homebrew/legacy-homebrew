require 'formula'

class Imageworsener < Formula
  homepage 'http://entropymine.com/imageworsener/'
  url 'http://entropymine.com/imageworsener/imageworsener-1.1.0.tar.gz'
  sha1 'ce552890396efc03f0e7860b74cd635e5185858d'
  revision 1

  depends_on 'libpng' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/imagew", "--version"
  end
end
