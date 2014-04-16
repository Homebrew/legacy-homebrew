require 'formula'

class Jpegoptim < Formula
  homepage 'https://github.com/tjko/jpegoptim'
  url 'https://github.com/tjko/jpegoptim/archive/RELEASE.1.3.0.tar.gz'
  sha1 '02bf879a6c2a960e51a9e2b45c6eb342b2363783'
  head 'https://github.com/tjko/jpegoptim.git'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
