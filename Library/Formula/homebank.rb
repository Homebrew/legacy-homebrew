class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.5.tar.gz"
  sha256 "67c47709517d325fc8d601bb8552e3c8a1ad3b820a2c0a403ed20f00c795903c"

  bottle do
    sha256 "9211fea3f0282cbf278d4a36763847b58e17e42b202b10762914dd19e79171bc" => :yosemite
    sha256 "7fef17d4bab46280e3546bdd1707a50a950621ff746f8bab7b82127eb27baed2" => :mavericks
    sha256 "f19878c6d82dd385e38cfe24f757e5364893a03f3eb1fbbc3a4582377155070e" => :mountain_lion
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
