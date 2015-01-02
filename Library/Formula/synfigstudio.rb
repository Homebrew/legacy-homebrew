require "formula"

class Synfigstudio < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.3/source/synfigstudio-0.64.3.tar.gz"
  sha1 "63655509a6a5920eb067021730abbb52164436f5"

  bottle do
    sha1 "feaa6217d845867d674f81f4380f46b98daf9aef" => :yosemite
    sha1 "08ee70dd675457e4664cfc091f094ac34b485a40" => :mavericks
    sha1 "ea2bf39df2c1798ac479c3a3c08c73b4815724cf" => :mountain_lion
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
