require "formula"

class Libmms < Formula
  homepage "http://sourceforge.net/projects/libmms/"
  url "https://downloads.sourceforge.net/project/libmms/libmms/0.6.4/libmms-0.6.4.tar.gz"
  sha1 "b03ef84a9eedc68fdf2866265b667b75e1a33bee"

  bottle do
    cellar :any
    sha1 "1cd72a029405e29646813c3fe332c65065bb9f3b" => :mavericks
    sha1 "ce77a403bda4b35b5aa47faf95fe0a88d3dd6799" => :mountain_lion
    sha1 "0cbec23db83d8c91ac3c146c8e499ee06148c39a" => :lion
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
