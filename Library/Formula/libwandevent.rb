class Libwandevent < Formula
  desc "Libwandevent provides an API for developing event-driven programs"
  homepage "http://research.wand.net.nz/software/libwandevent.php"
  url "http://research.wand.net.nz/software/libwandevent/libwandevent-3.0.1.tar.gz"
  sha256 "317b2cc39f912f8e5875b9dd05658cd48ead98bf20a1d89855e5a435381bee24"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sys/time.h>
      #include <libwandevent.h>

      int main() {
        wand_event_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwandevent", "-o", "test"
    system "./test"
  end
end
