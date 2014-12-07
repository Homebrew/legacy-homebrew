class Nghttp2 < Formula
  homepage "https://nghttp2.org"
  url "https://github.com/tatsuhiro-t/nghttp2/releases/download/v0.7.1/nghttp2-0.7.1.tar.gz"
  sha1 "58d73099513760375b29e38dd4f7fc7a46b00378"

  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "spdylay"
  depends_on "jansson"
  depends_on "boost"

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, we'll just use that.
  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules", "--disable-threads",
                          "--with-spdylay=#{Formula["spdylay"].opt_prefix}", "--enable-app",
                          "--with-boost=#{Formula["boost"].opt_prefix}", "--disable-python-bindings"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/nghttp", "-nv", "https://nghttp2.org"
  end
end
