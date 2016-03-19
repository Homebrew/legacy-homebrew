class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-1.1.0.tar.gz"
  sha256 "b89cef45bcc5ae4011aa3c42f689ae9fd7b5c8fd25e06ab18589577b5e077f89"

  bottle do
    cellar :any
    sha256 "5a94e3a2f3e36a0aa93c9c06e33d126079307080a7a8237cf719c9eb20c23272" => :el_capitan
    sha256 "c7fa0c3adcebc76cafb1cdb56116e8fcd111a62d144c82a00226676e5f6a1950" => :yosemite
    sha256 "a0a45f0c9c135d94c64772d273bf0e3cb462eb6b83663388b343665f0894015a" => :mavericks
  end

  depends_on "wandio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "bgpstream.h"
      int main()
      {
        bgpstream_t *bs = bs = bgpstream_create();
        if(!bs) {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbgpstream", "-o", "test"
    system "./test"
  end
end
