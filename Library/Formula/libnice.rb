require "formula"

class Libnice < Formula
  homepage "http://nice.freedesktop.org/wiki/"
  url "http://nice.freedesktop.org/releases/libnice-0.1.7.tar.gz"
  sha1 "94d459fc409da9cf5e4ac30d680ee6c0ded2cb64"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gstreamer"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure",  *args
    system "make install"
  end
end
