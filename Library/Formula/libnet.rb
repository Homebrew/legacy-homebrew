class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://downloads.sourceforge.net/project/libnet-dev/libnet-1.1.6.tar.gz"
  sha256 "d392bb5825c4b6b672fc93a0268433c86dc964e1500c279dc6d0711ea6ec467a"

  bottle do
    cellar :any
    revision 1
    sha256 "26a496e3607f2639592617769522a790259c834f91c05d91721331fe6f1ad0c4" => :el_capitan
    sha256 "4203e91b8334689591d1dcec4e2f11625b035dbef078dd7f63121dbf3959e69b" => :yosemite
    sha256 "fd35c44586c926e10d9cb616e2b33594cb553329735ff2fe9130adfa8ccf17da" => :mavericks
    sha256 "fb6a96f3af1521fa09982657342381cee8a681efe4f90cf50626a0a8a720c967" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  # Fix raw sockets support
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/a689647/libnet/patch-configure.in.diff"
    sha256 "3c1ca12609d83372cf93223d69e903eb6e137ed7a4749a8ee19c21bd43f97f18"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/libnet_link_bpf.c", "#include <net/bpf.h>", "" # Per MacPorts
    system "make", "install"
  end
end
