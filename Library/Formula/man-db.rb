require "formula"

class ManDb < Formula
  homepage "http://man-db.nongnu.org/"
  url "http://download.savannah.gnu.org/releases/man-db/man-db-2.6.7.1.tar.xz"
  sha1 "4c6f322529b929fb70263584f79dff6d615908ec"

  head do
    url "git://git.sv.gnu.org/man-db.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "groff" if OS.linux?
  depends_on "libpipeline"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/man --version"
  end
end
