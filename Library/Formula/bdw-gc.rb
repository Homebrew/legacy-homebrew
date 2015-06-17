require "formula"

class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.4.2.tar.gz"
  sha1 "cd4a54620c38a2c361b3ee99dd134dbffb57c313"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

  bottle do
    revision 1
    sha1 "3c5fdf16d5ddb72427e300a79b8aa829df51480d" => :yosemite
    sha1 "9c03aaf69cbda261bc263a65e922607a4cda3bd1" => :mavericks
    sha1 "365f19fe49db14430a858c812210ebc5e8bb0f5e" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end
