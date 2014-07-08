require "formula"

class I3 < Formula
  homepage "http://i3wm.org/"
  url "http://i3wm.org/downloads/i3-4.8.tar.bz2"
  sha1 "857d8d0014b873de406e2041dea94d81cc515b74"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"
  depends_on "libev"
  depends_on "pango"
  depends_on "pcre"
  depends_on "startup-notification"
  depends_on "yajl"
  depends_on :x11

  def install
    # In src/i3.mk, precompiled headers are used if CC=clang, however superenv
    # currently breaks the clang invocation, setting CC=cc works around this.
    system "make", "install", "CC=cc", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/i3", "-v"
  end
end
