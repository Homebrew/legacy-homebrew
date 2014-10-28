require "formula"

class Synfigstudio < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.2/source/synfigstudio-0.64.2.tar.gz"
  sha1 "632a3cb09c384c0ced398a2de00e7dc4ecfd481f"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "libsigc++"
  depends_on "gtkmm"
  depends_on "etl"
  depends_on "synfig"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
