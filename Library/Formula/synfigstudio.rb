require "formula"

class Synfigstudio < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.3/source/synfigstudio-0.64.3.tar.gz"
  sha1 "63655509a6a5920eb067021730abbb52164436f5"

  bottle do
    sha1 "c8eb2ea83ffc2ca9959c20588ee7c18fdcf706b4" => :yosemite
    sha1 "3f868438ff5edfe8468ab07637ee6235be824cf6" => :mavericks
    sha1 "efb9e2ae0fc67b8c66ed71b815962e7ac82a35f2" => :mountain_lion
  end

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
