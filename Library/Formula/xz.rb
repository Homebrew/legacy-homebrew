require 'formula'

class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://tukaani.org/xz/xz-5.0.3.tar.bz2'
  sha256 '5a11b9e17bfcda62319c5a8c4a2062dc81607a316d3f6adff89422d81ec1eae9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
