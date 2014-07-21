require "formula"

class Iptux < Formula
  homepage "https://github.com/iptux-src/iptux"
  url "https://github.com/iptux-src/iptux/archive/v0.6.2.tar.gz"
  sha1 "19c3984d7523f8563d91a2949b6fb0629ab6c586"

  depends_on :x11
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gconf"
  depends_on "hicolor-icon-theme"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/iptux", "--version"
  end
end
