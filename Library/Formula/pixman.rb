require 'formula'

class Pixman < Formula
  homepage 'http://www.cairographics.org/'
  url 'http://www.cairographics.org/releases/pixman-0.20.2.tar.gz'
  sha256 '27b4e58ae8dcf8787cc309bc2b119ca6b6e353b3283a7821896e454ae8bd9725'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no" # Don't need to build tests
    system "make install"
  end
end
