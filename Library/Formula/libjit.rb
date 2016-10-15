class Libjit < Formula
  homepage "https://www.gnu.org/software/libjit/"
  url "git://git.savannah.gnu.org/libjit.git"
  version "0.1.3"

  depends_on "gcc" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    gcc = Formula["gcc"]
    system "./auto_gen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{gcc.bin}/gcc-#{gcc.version_suffix}"
    system "make"
    system "make install"
  end
end
