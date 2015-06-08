class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "http://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.tar.gz"
  mirror "http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz"
  sha1 "f10c64e92d9c72ee428df3feaf349c4ecb2493bd"

  # No --default-names option as it interferes with Homebrew builds.

  bottle do
    sha1 "a8ae149dd4489d03d742e0ec2e8fc845e6501661" => :yosemite
    sha1 "525197640a994f0ce80ec61d26090a12e81ce16c" => :mavericks
    sha1 "8e71e8d290d3c71926ad1bb48b74b8cd462fce3d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
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
    assert `#{bin}/gnm #{bin}/gnm`.include? 'main'
    assert_equal 0, $?.exitstatus
  end
end
