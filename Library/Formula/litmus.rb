require 'formula'

class Litmus < Formula
  homepage 'http://www.webdav.org/neon/litmus/'
  url 'http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz'
  sha1 '42ad603035d15798facb3be79b1c51376820cb19'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
