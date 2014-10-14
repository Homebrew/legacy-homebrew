require "formula"

class Utimer < Formula
  homepage "http://utimer.codealpha.net/utimer/"
  url "http://utimer.codealpha.net/dl.php?file=utimer-0.4.tar.gz"
  sha1 "b9590ef4ff6bb8ecf64bb703f50f1bfeddf3fbdd"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
