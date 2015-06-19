class Libprotoident < Formula
  desc "Libprotoident performs application layer protocol identification"
  homepage "http://research.wand.net.nz/software/libprotoident.php"
  url "http://research.wand.net.nz/software/libprotoident/libprotoident-2.0.7.tar.gz"
  sha256 "5063497274e546b01b0606c8906a292cbe1e2ba8d6f3b6cd25de16a91fef635e"

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
