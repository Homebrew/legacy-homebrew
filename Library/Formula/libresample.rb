class Libresample < Formula
  desc "Audio resampling C library"
  homepage "https://ccrma.stanford.edu/~jos/resample/Available_Software.html"
  url "http://ftp.de.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz"
  sha256 "20222a84e3b4246c36b8a0b74834bb5674026ffdb8b9093a76aaf01560ad4815"

  bottle do
    cellar :any
    revision 1
    sha1 "493df1e911173a8e5a3a9ccd7ab6165186816e2a" => :yosemite
    sha1 "6e5b4b8d2ff893e3ff5df2562f49e39625283b36" => :mavericks
    sha1 "6b37a559dabe8fec702605ec28b26925e3afaefd" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install "libresample.a"
    include.install "include/libresample.h"
  end
end
