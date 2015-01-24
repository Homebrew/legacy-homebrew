class Libforensic1394 < Formula
  homepage "https://freddie.witherden.org/tools/libforensic1394/"
  url "https://freddie.witherden.org/tools/libforensic1394/releases/libforensic1394-0.2.tar.gz"
  sha1 "179526652977c291303e4f7edc3c7ed487eb0eca"
  head "git://git.freddie.witherden.org/forensic1394.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <forensic1394.h>
      int main() {
        forensic1394_bus *bus;
        bus = forensic1394_alloc();
        assert(NULL != bus);
        forensic1394_destroy(bus);
        return 0;
      }
      EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lforensic1394", "-o", "test"
    system "./test"
  end
end
