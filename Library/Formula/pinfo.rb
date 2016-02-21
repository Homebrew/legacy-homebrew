class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://alioth.debian.org/projects/pinfo/"
  url "https://alioth.debian.org/frs/download.php/file/3351/pinfo-0.6.10.tar.bz2"
  sha256 "122180a0c23d11bc9eb569a4de3ff97d3052af96e32466fa62f2daf46ff61c5d"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gettext"
  depends_on "readline" => :optional

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "pinfo", "-h"
  end
end
