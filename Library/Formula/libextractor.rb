require 'formula'

class Libextractor < Formula
  homepage 'http://www.gnu.org/software/libextractor/'
  url 'http://ftpmirror.gnu.org/libextractor/libextractor-0.6.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libextractor/libextractor-0.6.3.tar.gz'
  sha1 '58ca71d04fcbac6ea9675bd91ffa18a26c865ebc'

  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/extract", "-v"
  end
end
