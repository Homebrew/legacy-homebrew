require "formula"

class Nghttp2 < Formula
  homepage "https://nghttp2.org"
  url "https://github.com/tatsuhiro-t/nghttp2/releases/download/v0.6.5/nghttp2-0.6.5.tar.bz2"
  sha1 "8743e8b2208dc09fdab82feea5c3c027c2ba3468"

  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "openssl"
  depends_on "libevent"
  depends_on "spdylay"
  depends_on "jemalloc"
  depends_on "jansson"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-spdylay", "--enable-app",
                          "--disable-threads", "--disable-python-bindings"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/nghttp", "-nv", "https://nghttp2.org"
  end
end
