class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://alioth.debian.org/projects/pinfo/"
  url "https://alioth.debian.org/frs/download.php/file/3351/pinfo-0.6.10.tar.bz2"
  sha256 "122180a0c23d11bc9eb569a4de3ff97d3052af96e32466fa62f2daf46ff61c5d"

  bottle do
    sha256 "b16b4d3ad4086adbb409cc7b5122cb5002df29f4fcec79510ec1b6b1678139b0" => :el_capitan
    sha256 "f17994059227efc06af65d1e7d7be4fcd3a0907c3f64ad58336df61e12dab847" => :yosemite
    sha256 "8accf82707225645802b54c80e2db03b08fae54abe03d86cb94f9244606ce5a0" => :mavericks
  end

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
