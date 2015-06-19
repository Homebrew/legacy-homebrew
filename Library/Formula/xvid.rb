class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.org"
  url "https://fossies.org/unix/privat/xvidcore-1.3.3.tar.gz"
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror "http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz"
  sha256 "9e6bb7f7251bca4615c2221534d4699709765ff019ab0366609f219b0158499d"

  bottle do
    cellar :any
    revision 2
    sha256 "c152517b75984c64ed0bf4e37a383feb7b88aee70a8d3249b4f9d7ea1e4314be" => :yosemite
    sha256 "65f9ccd09973b890288f77aa0c01c01587e0a5209a3b63f2b237de2a942f95e1" => :mavericks
    sha256 "d2b3dfcc3c0f53b5dbc530b4ddfc67227b0a7c0520bb0a01f7d6922c39c47dca" => :mountain_lion
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
