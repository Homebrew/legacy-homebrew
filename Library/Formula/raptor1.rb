require 'formula'

class Raptor1 < Formula
  homepage 'http://librdf.org/raptor/'
  url 'http://download.librdf.org/source/raptor-1.4.21.tar.gz'
  sha1 'f8a82c6e9a342d0cc9772a02562c5e29c2c9b737'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
