class Libwandevent < Formula
  desc "Libwandevent provides an API for developing event-driven programs"
  homepage "http://research.wand.net.nz/software/libwandevent.php"
  url "http://research.wand.net.nz/software/libwandevent/libwandevent-3.0.1.tar.gz"
  sha256 "317b2cc39f912f8e5875b9dd05658cd48ead98bf20a1d89855e5a435381bee24"

  bottle do
    cellar :any
    sha256 "e6a07c41e838e86d5a1c39274d5d15e37d55dd7439f19a05a50818fd78f437e5" => :yosemite
    sha256 "5565d710cbaeb8110f2f50289965dc0cfc76d20ddb96138ddbbadd452b13eefc" => :mavericks
    sha256 "63c6840e4140921671922f960b63a48565fb0204ae2646d3355bf20f6e5c3958" => :mountain_lion
  end

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
