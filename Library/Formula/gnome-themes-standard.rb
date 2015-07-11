class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.16/gnome-themes-standard-3.16.2.tar.xz"
  sha256 "59eb79a59d44b5cd8daa8de1e7559fb5186503dcd78e47d0b72cb896d8654b9f"

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
