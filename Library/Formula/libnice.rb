require "formula"

class Libnice < Formula
  homepage "http://nice.freedesktop.org/wiki/"
  url "http://nice.freedesktop.org/releases/libnice-0.1.7.tar.gz"
  sha1 "94d459fc409da9cf5e4ac30d680ee6c0ded2cb64"

  bottle do
    cellar :any
    revision 1
    sha1 "8040ab61239c18ac7fd55c661c810115c57ad94f" => :yosemite
    sha1 "d7e063ed0efe3d2d1873843a9b15a0a3e6ec0b51" => :mavericks
    sha1 "e5bc420dad36c42a8cfc57a1a089aa4f6dd1d122" => :mountain_lion
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
