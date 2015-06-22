class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.2.tar.gz"
  sha256 "f2c3f9da0aa9af76cfed63a19104d99d33b1766cac89dd1586c378b9cf54a2ca"
  revision 1

  bottle do
    revision 1
    sha256 "f6e9b9f19a0e86678d91dddc53760b0387fe6af32846e189d30222d560b04735" => :yosemite
    sha256 "d215f28742deee07a858b4bdc224a231d92574fcf55fe31c4d7f95b83a1072cb" => :mavericks
    sha256 "f733d5b201ab5408abf26bad47dc7393553c44d6f1e5248f6d8358217c8d8160" => :mountain_lion
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
