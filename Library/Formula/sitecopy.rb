require 'formula'

class Sitecopy < Formula
  url 'http://www.manyfish.co.uk/sitecopy/sitecopy-0.16.6.tar.gz'
  homepage 'http://www.manyfish.co.uk/sitecopy/'
  sha1 '2de3679d98c31331f48ff10e824c615a180f2d3b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml2",
                          "--with-ssl"
    system "make install"
  end
end
