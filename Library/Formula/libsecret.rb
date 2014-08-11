require "formula"

class Libsecret < Formula
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.tar.xz"
  sha1 "af62de3958bbe0ccf59a02101a6704e036378a6f"

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext' => :build
  depends_on 'glib'
  depends_on 'libgcrypt'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    inreplace "Makefile", 'sed', 'gsed'
    inreplace "Makefile", '--nonet', ''
    system "make", "install"
  end
end
