require 'formula'

class Jpegoptim < Formula
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  url 'http://www.kokkonen.net/tjko/src/jpegoptim-1.3.0.tar.gz'
  sha1 '5cf5945cbb2245fb7a2c7217947e43bcbd943b7d'
  head 'https://github.com/tjko/jpegoptim.git'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
