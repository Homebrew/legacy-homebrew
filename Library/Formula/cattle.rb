class Cattle < Formula
  homepage "https://github.com/andreabolognani/cattle"
  url "https://github.com/andreabolognani/cattle/archive/cattle-1.2.0.tar.gz"
  sha256 "ff0b424011c56f61cb463f1d3fb32e58e40da41260298c407bd0748eb506468d"
  head "https://github.com/andreabolognani/cattle.git"

  # https://github.com/andreabolognani/cattle/issues/2
  patch do
    url "https://github.com/andreabolognani/cattle/pull/3.diff"
    sha256 "876802fd965050d95e9cd7836b71a3cac5cd2508bf7f45b17192803a6fe19c17"
  end

  depends_on "gtk-doc" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
