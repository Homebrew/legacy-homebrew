require 'formula'

class Minidjvu < Formula
  homepage 'http://minidjvu.sourceforge.net/'
  url 'http://sourceforge.net/projects/minidjvu/files/minidjvu/0.8/minidjvu-0.8.tar.gz'
  md5 'b354eb74d83c6e2d91aab2a6c2879ba7'

  depends_on 'djvulibre'
  depends_on 'libtiff'

  def install
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    lib.install Dir["#{prefix}/*.dylib"]
  end

  def test
  end
end
