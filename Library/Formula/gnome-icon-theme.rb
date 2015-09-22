class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.16/adwaita-icon-theme-3.16.2.1.tar.xz"
  sha256 "b4556dfbf555d4fac12d4d5c12f7519de0d43ec42a1b649611439a50bf7acb96"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2044306ce437167a3a35b955e4fdd5231a1a264cc6d76d7633c7074d8cb509a" => :el_capitan
    sha256 "280b69b14c0c526ca652ce6246c64e4a9c3446836f50d8e8bb050fe9cd69489a" => :yosemite
    sha256 "91d0523ab7ba7d8443bcd031530a70842a7d6a708576b65828dc991cbec83042" => :mavericks
    sha256 "0860138b37323829ea795e18f6bc46a23d5da03369bfa197796e3bd2347add5e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "icon-naming-utils" => :build
  depends_on "intltool" => :build
  depends_on "librsvg" => :build

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
