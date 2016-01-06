class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "http://libestr.adiscon.com"
  url "http://libestr.adiscon.com/files/download/libestr-0.1.10.tar.gz"
  sha256 "bd655e126e750edd18544b88eb1568d200a424a0c23f665eb14bbece07ac703c"

  bottle do
    cellar :any
    revision 1
    sha256 "264f2776c2a96422ef61ff1b4a3d9e279bf939682e5ce262ac4a12388feec616" => :yosemite
    sha256 "eb87097b581060832ac2e824580b3170d9d90866dfe5013d6be2c8040dc494ef" => :mavericks
    sha256 "99af2bd65207f3f4b7ed2250cdc1cdf8fd01868259d251714851d93dfee1581b" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "stdio.h"
      #include <libestr.h>
      int main() {
        printf("%s\\n", es_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lestr", "-o", "test"
    system "./test"
  end
end
