require 'formula'

class Libextractor < Formula
  homepage 'http://www.gnu.org/software/libextractor/'
  url 'http://ftpmirror.gnu.org/libextractor/libextractor-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libextractor/libextractor-1.2.tar.gz'
  sha1 'c10a5a20a1850b8e89eeb41f3f2eccb7db9d5e53'

  depends_on 'pkg-config' => :build
  depends_on :libtool => :run
  depends_on 'iso-codes' => :optional

  def install
    ENV.deparallelize
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/extract", "-v"
  end
end
