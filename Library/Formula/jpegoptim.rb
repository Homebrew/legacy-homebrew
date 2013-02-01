require 'formula'

class Jpegoptim < Formula
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  url 'http://www.kokkonen.net/tjko/src/jpegoptim-1.2.4.tar.gz'
  sha1 '262774406d97653cc43bf2d19d91a85133f81f79'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
