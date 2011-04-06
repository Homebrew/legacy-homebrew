require 'formula'

class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://tukaani.org/xz/xz-5.0.2.tar.bz2'
  sha1 'c244dfffef4196b997035d7389e957f56a3a87d1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
