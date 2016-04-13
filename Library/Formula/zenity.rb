class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.20/zenity-3.20.0.tar.xz"
  sha256 "02e8759397f813c0a620b93ebeacdab9956191c9dc0d0fcba1815c5ea3f15a48"

  bottle do
    sha256 "f0017ba4ecdcdb89d8339ea2efefed1c1d7753544899cde824cd59864761710e" => :el_capitan
    sha256 "0e585f77e9f945c54a3257f3f212bc2f19aff927475090b73ffa83e98b32e3c4" => :yosemite
    sha256 "8cf1d00ab9bedf112479aa4f503ec475379046e90916364a65e169766d87e0e8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"
  depends_on "webkitgtk" => :recommended


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/zenity", "--help"
  end
end
