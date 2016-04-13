class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.20/gnome-themes-standard-3.20.tar.xz"
  sha256 "1cde84b34da310e6f2d403bfdbe9abb0798e5f07a1d1b4fde82af8e97edd3bdc"

  bottle do
    cellar :any
    sha256 "fdd2ceb4074c51b300a9777d54d5eb6b2d37e1dc0b7f4bc70c8215bf042bfa0b" => :el_capitan
    sha256 "594a1b8339120e31d0575234b0e9071daec6457a28c7d0d87ec8548311a0d64d" => :yosemite
    sha256 "adcb641a47869ea2f41c6d5fd277c39496c8203256efa92fc1d8810802a693ed" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk3-engine"

    system "make", "install"
  end

  test do
    assert (share/"icons/HighContrast/scalable/actions/document-open-recent.svg").exist?
    assert (lib/"gtk-2.0/2.10.0/engines/libadwaita.so").exist?
  end
end
