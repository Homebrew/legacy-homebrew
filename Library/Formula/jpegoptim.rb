require 'formula'

class Jpegoptim < Formula
  homepage 'https://github.com/tjko/jpegoptim'
  url 'https://github.com/tjko/jpegoptim/archive/RELEASE.1.3.1.tar.gz'
  sha1 'c7264e3a6c59cc4ee919ca6e4c9db02076da2476'
  head 'https://github.com/tjko/jpegoptim.git'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
