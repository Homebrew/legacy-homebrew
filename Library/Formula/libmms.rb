require "formula"

class Libmms < Formula
  homepage "http://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha1 "b03ef84a9eedc68fdf2866265b667b75e1a33bee"

  bottle do
    cellar :any
    revision 1
    sha1 "775dd094b8e1d7ac7a8466321241341f8f05be2e" => :yosemite
    sha1 "ccc9dc73c3512d932d529853398199fc3995a84f" => :mavericks
    sha1 "38786ae43d15c27862bd003e1fc779c24e2f1863" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  # https://trac.macports.org/ticket/27988
  patch :p0 do
    url "https://trac.macports.org/export/87883/trunk/dports/multimedia/libmms/files/src_mms-common.h.patch"
    sha1 "57b526dc9de76cfde236d3331e18eb7ae92f999f"
  end if MacOS.version <= :leopard

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
