require 'formula'

class Pixman < Formula
  url 'http://www.cairographics.org/releases/pixman-0.21.6.tar.gz'
  homepage 'http://www.cairographics.org/'
  sha1 'b22aaafc3b637470c9f04fae565e2a22eaf5e00a'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no" # Don't need to build tests
    system "make install"
  end
end
