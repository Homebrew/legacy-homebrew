class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.org"
  url "https://fossies.org/unix/privat/xvidcore-1.3.4.tar.gz"
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
  sha256 "4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f"

  bottle do
    cellar :any
    sha256 "9348879c2506816f6975bf62d3d9b1457b36b9c0093f8b08adffcb27005b5714" => :el_capitan
    sha256 "6c4882ee38401986bc42a7121d7c83674e4605f73f70e25d7cf49f8064ad39c5" => :yosemite
    sha256 "b3d6623ad887d3e9c663580f87460b18c89d40d14d81cc281c3aa5752bcbc26a" => :mavericks
    sha256 "08dbe9151754cbf5920c01f003c9c2a419455c3f01dd2679eb8bc9b25c5190a5" => :mountain_lion
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
