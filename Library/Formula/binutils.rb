class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz"
  sha256 "cccf377168b41a52a76f46df18feb8f7285654b3c1bd69fc8265cb0fc6902f2d"

  # --default-names interferes with Mac builds.
  option "with-default-names", "Do not prepend 'g' to the binary" if OS.linux?
  deprecated_option "default-names" => "with-default-names"

  bottle do
    revision 1
    sha256 "fbfd4708fb7ce4406b628f376aacd91c2af0aa09ea3e09f97727c312ee7e969d" => :yosemite
    sha256 "1b0c1fb4b1fc53cca1194bde7d8281cb11cf4f34b245084737cccac2dadb860e" => :mavericks
    sha256 "971e274200aa6a63469aafc0a65a86427f44d8a78fe00e61225ca9edd75ba0d3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--program-prefix=g" if build.without? "default-names"),
                          ("--with-sysroot=/" if OS.linux?),
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert_match /main/, shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
