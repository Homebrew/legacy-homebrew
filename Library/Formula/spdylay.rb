require 'formula'

class Spdylay < Formula
  homepage 'https://github.com/tatsuhiro-t/spdylay'
  url 'https://github.com/tatsuhiro-t/spdylay/archive/release-1.1.0.tar.gz'
  sha1 'b230b9fd9c32c2573cf6d99d2e756208a0c09e49'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libxml2'
  depends_on 'openssl'

  def install
    system 'autoreconf -i'
    system 'automake'
    system 'autoconf'

    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end
