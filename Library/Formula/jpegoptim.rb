require 'formula'

class Jpegoptim < Formula
  url 'http://www.kokkonen.net/tjko/src/jpegoptim-1.2.4.tar.gz'
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  sha1 '262774406d97653cc43bf2d19d91a85133f81f79'

  depends_on 'jpeg'

  def install
    ENV.j1 # Install is not parallel-safe
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
