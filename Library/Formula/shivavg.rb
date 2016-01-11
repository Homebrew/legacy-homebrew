class Shivavg < Formula
  desc "OpenGL based ANSI C implementation of the OpenVG standard"
  homepage "https://sourceforge.net/projects/shivavg/"
  url "https://downloads.sourceforge.net/project/shivavg/ShivaVG/0.2.1/ShivaVG-0.2.1.zip"
  sha256 "9735079392829f7aaf79e02ed84dd74f5c443c39c02ff461cfdd19cfc4ae89c4"

  bottle do
    cellar :any
    sha256 "3e9de2887110c90051ad5b89080f62cd5990ae39f8fdef02a4c50ba11e413ca8" => :el_capitan
    sha256 "f3de3b35fcfeff41c1836bc7722579d1d4b461e10d4152802bae1ab48b5a3bbb" => :yosemite
    sha256 "e9bdb03d76c994311a7e38c95eb40561bcb8f7fefdc12ac80137724f39a6bb4a" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-example-all=no"
    system "make", "install"
  end
end
