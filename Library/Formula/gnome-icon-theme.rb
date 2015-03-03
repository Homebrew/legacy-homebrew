class GnomeIconTheme < Formula
  homepage "https://developer.gnome.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/adwaita-icon-theme/3.14/adwaita-icon-theme-3.14.1.tar.xz"
  sha1 "e1d603d9cc4e4b7f83f749ba20934832d4321dd2"

  bottle do
    cellar :any
    sha1 "e9329d81e8c615e78f0c96e62b91008dbc4a74e5" => :mavericks
    sha1 "84c1e818410a0c5b8b33c6b07932b8a547f69ede" => :mountain_lion
    sha1 "3bbeb7cee6c7bd1e1b070cc0be276502eee3cc6b" => :lion
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
