require 'formula'

class Libextractor < Formula
  homepage 'http://www.gnu.org/software/libextractor/'
  url 'http://ftpmirror.gnu.org/libextractor/libextractor-1.0.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libextractor/libextractor-1.0.1.tar.gz'
  sha1 '244eb3e16dadedea9dc827fb91cb309e2baa8637'

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
