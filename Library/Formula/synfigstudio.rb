class Synfigstudio < Formula
  desc "Vector-based 2D animation package"
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0/source/synfigstudio-1.0.tar.gz"
  sha256 "2b23916ca0be4073edad9b0cb92fd30311dd3b8f73372c836ba735100251ee28"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "libsigc++"
  depends_on "gtkmm3"
  depends_on "etl"
  depends_on "synfig"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # executable doesnt take options that will stop the gui from spawning
    assert (share/"appdata/synfigstudio.appdata.xml").exist?
  end
end
