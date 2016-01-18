class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  head "http://git.srcbox.net/gkrellm", :using => :git

  stable do
    url "https://billw2.github.io/gkrellm/gkrellm-2.3.5.tar.bz2"
    sha256 "702b5b0e9c040eb3af8e157453f38dd6f53e1dcd8b1272d20266cda3d4372c8b"

    # http://git.srcbox.net/gkrellm/commit/?id=207a0519ac73290ba65b6e5f7446549a2a66f5d2
    # Resolves a NULL value crash. Fixed upstream already but unreleased in stable.
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/8040a52382/gkrellm/nullpointer.patch"
      sha256 "d005e7ad9b4c46d4930ccb4391481716b72c9a68454b8d8f4dfd2b597bfd77cc"
    end
  end

  bottle do
    sha256 "1b33628604f2b3577d020a32ddf61af1dd4ae3cf7f52fc62617ea2a842e4d842" => :el_capitan
    sha256 "64e1bf668b44b8a056d3f07d0644012f5778b42654d1d656bcba595f640786c7" => :yosemite
    sha256 "f4ff4fc7fecd7ec1c057a329789546e7533c6fee7bf59b19901027c777ad9395" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "openssl"

  def install
    # Fixes broken pkg-config call. Without this compile fails on linking errors.
    # Already fixed upstream but unreleased.
    if build.stable?
      inreplace "src/Makefile", "gtk+-2.0 gthread-2.0", "gtk+-2.0 gthread-2.0 gmodule-2.0"
    end

    system "make", "INSTALLROOT=#{prefix}", "macosx"
    system "make", "INSTALLROOT=#{prefix}", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    end
    sleep 2

    begin
      assert File.exist?("test.pid")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
