require 'formula'

class Libao < Formula
  homepage 'http://www.xiph.org/ao/'
  url 'http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz'
  sha1 '6b1d2c6a2e388e3bb6ebea158d51afef18aacc56'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make install"
  end
end
