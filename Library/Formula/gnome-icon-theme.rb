class GnomeIconTheme < Formula
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.16/adwaita-icon-theme-3.16.0.tar.xz"
  sha256 "a3c8ad3b099ca571b423811a20ee9a7a43498cfa04d299719ee43cd7af6f6eb1"

  bottle do
    cellar :any
    sha256 "b1ec7cce3cfe5d32d9a89db1dbb1a5dd44e38658985d5e8c06c4f068b30c5e8d" => :yosemite
    sha256 "4e13f93459296b61c9bd9fd676043b36fa1647d5b499f6b5fb16b2df9f3412e3" => :mavericks
    sha256 "d028a6e7c2bff311e4f6f60fa46ee20bc741e548fbc7569b92aba2b7b9f8e64d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "icon-naming-utils" => :build
  depends_on "intltool" => :build
  depends_on "librsvg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "GTK_UPDATE_ICON_CACHE=#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache"
    system "make", "install"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK+3 could probably write better tests that
    # check if GTK+3 can find the icons.
    assert (share/"icons/Adwaita/96x96/status/weather-storm-symbolic.symbolic.png").exist?
    assert (share/"icons/Adwaita/index.theme").exist?
  end
end
