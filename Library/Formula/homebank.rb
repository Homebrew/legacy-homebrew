class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.5.tar.gz"
  sha256 "67c47709517d325fc8d601bb8552e3c8a1ad3b820a2c0a403ed20f00c795903c"

  bottle do
    sha256 "85940b9ae4c53bb2c8e695fe08f37d62c452f787f325b99c001d554d4a386ade" => :el_capitan
    sha256 "50c43e81113c16f6cf80f759b97148d86f2a0a56b169daf8c461d63dfc1e0fc0" => :yosemite
    sha256 "9410c4903e45074e55a72539bb9fc99ef5964dc8775574086f253ddf7a2a88c0" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libofx" => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
