class Liblaxjson < Formula
  desc "C library for parsing relaxed JSON config file"
  homepage "https://github.com/andrewrk/liblaxjson"
  url "https://github.com/andrewrk/liblaxjson/archive/1.0.5.tar.gz"
  sha256 "ffc495b5837e703b13af3f5a5790365dc3a6794f12f0fa93fb8593b162b0b762"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <laxjson.h>
      static struct LaxJsonContext *json;
      int main() {
        json = lax_json_create();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llaxjson", "-o", "test"
    system "./test"
  end
end
