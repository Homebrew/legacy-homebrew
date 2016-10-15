require "formula"

class Nghttp2 < Formula
  homepage "https://nghttp2.org"
  url "https://github.com/tatsuhiro-t/nghttp2/releases/download/v0.6.7/nghttp2-0.6.7.tar.bz2"
  sha1 "67c5851658851f5e3e38d8a571812ba32d301ab9"

  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "openssl"
  depends_on "libevent"
  depends_on "spdylay"
  depends_on "jemalloc"
  depends_on "jansson"

  def install
    ENV["ZLIB_CFLAGS"] = "-I/usr/include"
    ENV["ZLIB_LIBS"] = "-L/usr/lib -lz"

    system "./configure", "--prefix=#{prefix}", "--with-spdylay=#{HOMEBREW_PREFIX}/opt/spdylay", "--enable-app",
                          "--disable-threads", "--disable-python-bindings"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/nghttp", "-nv", "https://nghttp2.org"
  end
end
