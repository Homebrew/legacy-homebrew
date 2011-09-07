require 'formula'

class Jpegoptim < Formula
  url 'http://www.kokkonen.net/tjko/src/jpegoptim-1.2.4.tar.gz'
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  md5 '40e8e627181f524ad29717c5b07cd442'

  depends_on 'jpeg'

  def install
    ENV.j1 # Install is not parallel-safe
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
