require "formula"

class Owfs < Formula
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/2.9p5/owfs-2.9p5.tar.gz"
  version "2.9p5"
  sha1 "3fa215e2144ed8efa781d3dd1b2e7518b402b3b8"

  depends_on "libusb-compat"

  def install
    # Fix include of getline and strsep to avoid crash
    inreplace "configure", "-D_POSIX_C_SOURCE=200112L", ""

    # 'tac' command is missing in MacOSX
    inreplace "src/man/Makefile.am", "tac", "tail -r"
    inreplace "src/man/Makefile.in", "tac", "tail -r"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/owserver", "--version"
  end
end
