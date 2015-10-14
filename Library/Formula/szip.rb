class Szip < Formula
  desc "Implementation of extended-Rice lossless compression algorithm"
  homepage "https://www.hdfgroup.org/HDF5/release/obtain5.html#extlibs"
  url "https://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
  sha256 "a816d95d5662e8279625abdbea7d0e62157d7d1f028020b1075500bf483ed5ef"

  bottle do
    cellar :any
    revision 1
    sha256 "c2264ab5d3e0070040c9eb82ed44ff384d79d3e1c279266a1621172c44de1c0a" => :el_capitan
    sha256 "b8ad0f2ea77da1bc013fd3ea10104f3958389c76aa11fe33d4c79111a3605918" => :yosemite
    sha256 "df5cfb198d5fbdc45bf9e386ffcf25535b995ca32477afe03ca2d277443ef022" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <stdlib.h>
      #include <stdio.h>
      #include "szlib.h"

      int main()
      {
        sz_stream c_stream;
        c_stream.bits_per_pixel = 8;
        c_stream.pixels_per_block = 8;
        c_stream.pixels_per_scanline = 16;
        assert(SZ_CompressInit(&c_stream) == SZ_OK);
        assert(SZ_CompressEnd(&c_stream) == SZ_OK);
        return 0;
      }
    EOS
    system ENV.cc, "-lsz", "test.c", "-o", "test"
    system "./test"
  end
end
