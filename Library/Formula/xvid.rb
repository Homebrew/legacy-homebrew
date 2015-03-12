class Xvid < Formula
  homepage "http://www.xvid.org"
  url "https://fossies.org/unix/privat/xvidcore-1.3.3.tar.gz"
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror "http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz"
  sha256 "9e6bb7f7251bca4615c2221534d4699709765ff019ab0366609f219b0158499d"

  bottle do
    cellar :any
    revision 1
    sha1 "7909530c342faf017a3182e8393e24eaf11ebd02" => :yosemite
    sha1 "f8c77d6d2ea36943646f6ffcfcc999db50d62bab" => :mavericks
    sha1 "d0df269c7a0ef1e6c1d2a05ef0e8b9cea0b2d461" => :mountain_lion
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.j1 # Or make fails
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <xvid.h>
      #define NULL 0
      int main() {
        xvid_gbl_init_t xvid_gbl_init;
        xvid_global(NULL, XVID_GBL_INIT, &xvid_gbl_init, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxvidcore", "-o", "test"
    system "./test"
  end
end
