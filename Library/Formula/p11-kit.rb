require 'formula'

class P11Kit < Formula
  homepage 'http://p11-glue.freedesktop.org'
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.14.tar.gz'
  sha256 '7a5e561b8b4c6e25ed7a89ef36c8127437c8f18bd86fe4cd41d899c5c7def6d3'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # Bug workaround: https://bugs.freedesktop.org/show_bug.cgi?id=57714
    mv 'tests/.libs/mock-one.so', 'tests/.libs/mock-one.dylib'

    system "make check"
    system "make install"
  end
end
