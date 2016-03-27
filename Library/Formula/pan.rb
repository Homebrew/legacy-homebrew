class Pan < Formula
  desc "Usenet newsreader"
  homepage "http://pan.rebelbase.com"
  url "http://pan.rebelbase.com/download/releases/0.140/source/pan-0.140.tar.bz2"
  sha256 "ba1c65ee75b9eca1f15f6249ea762492309731446edc8b09085b63ad34351c71"

  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme" => :recommended
  depends_on "gnutls" => :optional
  depends_on "gtkspell3" => :optional
  depends_on "webkitgtk" => :optional

  def install
    ENV.append "LDFLAGS", "-liconv" # iconv detection is broken.
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--with-gtk3",
            "--prefix=#{prefix}"]
    args << "--with-gnutls" if build.with?("gnutls")
    args << "--with-webkit" if build.with?("webkitgtk")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pan", "-h"
  end
end
