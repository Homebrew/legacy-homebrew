class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "http://research.wand.net.nz/software/libprotoident.php"
  url "http://research.wand.net.nz/software/libprotoident/libprotoident-2.0.7.tar.gz"
  sha256 "5063497274e546b01b0606c8906a292cbe1e2ba8d6f3b6cd25de16a91fef635e"

  bottle do
    cellar :any
    revision 1
    sha256 "9f761841d9dd58fcdadbe545d52832bf05efa3b84b936a60c4e2fa564de101a1" => :el_capitan
    sha256 "a3c9fed0934c5e8c8f414cdc2abc7b1dec3dd991d97b2d9f057fb1a66ac0e550" => :yosemite
    sha256 "7a9c3dfc6052466f4be61cca44996ef98654f9c40d7da26e3e96be4ae17730d3" => :mavericks
  end

  depends_on "libflowmanager"
  depends_on "libwandevent"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
