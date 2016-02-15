class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.6.tar.gz"
  sha256 "4a52ef7a20accd50f8cead0d0564042912573c7d60887ef5e4d462fb28b239e4"

  bottle do
    sha256 "07d147dcb3410ca05271f7adb41a5414f108c59e659c6a4f0255f79dcfa7487f" => :el_capitan
    sha256 "383b722e42c3d1d0b1a46516a9804120b5cdc93dc117c99081c3f17743e8ee93" => :yosemite
    sha256 "ac44fb6b35c39791a9b71d2673178e520440527aa1255df49421c1a40c56e7c3" => :mavericks
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
