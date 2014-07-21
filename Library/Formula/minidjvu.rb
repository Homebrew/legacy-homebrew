require 'formula'

class Minidjvu < Formula
  homepage 'http://minidjvu.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz'
  sha1 '23835f73bc3580b72c6afe1f77feaf1e2611e714'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'djvulibre'
  depends_on 'libtiff'

  def install
    ENV.j1
    # force detection of BSD mkdir
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    lib.install Dir["#{prefix}/*.dylib"]
  end
end
