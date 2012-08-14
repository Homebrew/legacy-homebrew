require 'formula'

class Imageworsener < Formula
  homepage 'http://entropymine.com/imageworsener/'
  url 'http://entropymine.com/imageworsener/imageworsener-src-0.9.10.tar.gz'
  sha1 'd908a08e3e402052a22390aa865cbb5a6e30d465'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/imagew", "--version"
  end
end
