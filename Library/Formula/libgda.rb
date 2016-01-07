class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.4.tar.xz"
  sha256 "2cee38dd583ccbaa5bdf6c01ca5f88cc08758b9b144938a51a478eb2684b765e"

  bottle do
    sha256 "86f2882b0231fea79c6d84adc064ca163794cfdcc904137c7e14d6130fef162b" => :el_capitan
    sha256 "2738974d4592d4d760c64a793e9e140a74f8a93c2292c3baee3e64f6506b521d" => :yosemite
    sha256 "89a345a4eff5729024d6ba8b9425c3fa8408f2349d0205d095e9c5e26e55094d" => :mavericks
    sha256 "cf2ce1122dfe0f754f811a901114bfa5e4918368ec1acfb915038c2ec84c5215" => :mountain_lion
  end

  revision 1

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"
  depends_on "libgcrypt"
  depends_on "sqlite"
  depends_on "openssl"
  depends_on "mysql" => :optional
  depends_on "mysql56" => :optional

  def install
    ENV.libxml2
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java"
    system "make"
    system "make", "install"
  end
end
