require "formula"

class Libnice < Formula
  homepage "http://nice.freedesktop.org/wiki/"
  url "http://nice.freedesktop.org/releases/libnice-0.1.7.tar.gz"
  sha1 "94d459fc409da9cf5e4ac30d680ee6c0ded2cb64"

  bottle do
    cellar :any
    sha1 "75a3d506cc2c9cc994cbbb441c738e84a6e5928a" => :mavericks
    sha1 "c12e39da19cfe80dad26c5dcdf4c39bffb5941f5" => :mountain_lion
    sha1 "33d289f519c836b381440b547e258a470abc7bd2" => :lion
  end

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
