class Libresample < Formula
  desc "Audio resampling C library"
  homepage "https://ccrma.stanford.edu/~jos/resample/Available_Software.html"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz"
  sha256 "20222a84e3b4246c36b8a0b74834bb5674026ffdb8b9093a76aaf01560ad4815"

  bottle do
    cellar :any
    revision 1
    sha256 "c39ce9a7a453628e13f64c2de3a109ddcdba8f90fa0b4dd437b03d7c7a12f372" => :yosemite
    sha256 "e33b8ebd4536680314863dad42bb37a742602894542d1cf230ae10f94af0608e" => :mavericks
    sha256 "b227998aa09a85b0de27361e4574313e4754d0b54b9de56b183ef0e2c4843383" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install "libresample.a"
    include.install "include/libresample.h"
  end
end
