require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'https://github.com/downloads/openexr/openexr/ilmbase-1.0.3.tar.gz'
  sha1 '20597d2a27e3b580e0972576e6b07bf4836b5dc6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

