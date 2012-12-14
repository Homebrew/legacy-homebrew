require 'formula'

class Spdylay < Formula
  homepage 'https://github.com/tatsuhiro-t/spdylay'
  url 'https://github.com/tatsuhiro-t/spdylay/archive/release-0.3.6.tar.gz'
  sha1 '23a69c59ff3a9bd26a76d16d5d3bb4393bd7c5d7'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'zlib'
  depends_on 'libxml2'
  depends_on 'openssl'

  def install

    system "autoreconf -i"
    system "automake"
    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "spdycat", "-ns", "https://www.google.com"
  end
end
