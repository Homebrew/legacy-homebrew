require "formula"

class Gtksourceview3 < Formula
  homepage "http://projects.gnome.org/gtksourceview/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.14/gtksourceview-3.14.2.tar.xz"
  sha256 "b3c4a4f464fdb23ecc708a61c398aa3003e05adcd7d7223d48d9c04fe87524ad"

  bottle do
    sha1 "7ff4f773b49943b3875b2c05b1d44f830f74ed43" => :yosemite
    sha1 "9ffe22317e7a38a22058308141235090bd32b235" => :mavericks
    sha1 "9cb6385b341def8476ed445ef2223f72601878f7" => :mountain_lion
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
