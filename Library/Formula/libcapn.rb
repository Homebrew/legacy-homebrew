require 'formula'

class Libcapn < Formula
  homepage 'http://libcapn.org/'
  url 'http://libcapn.org/download/libcapn-1.0.0b3-src.tar.gz'
  sha1 'a53f7b382e683249ff55214b1effbae5f82c4ef2'
  head 'https://github.com/adobkin/libcapn.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  def install
    inreplace 'CMakeLists.txt', /usr\/lib\/pkgconfig/, "#{lib}/pkgconfig" unless build.head?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/'test_install.c').write <<-TEST_SCRIPT.undent
    #include <apn.h>
    int main() {
        apn_ctx_ref ctx = NULL;
        apn_error_ref error;
        if (apn_init(&ctx, "apns-dev-cert.pem", "apns-dev-key.pem", NULL, &error) == APN_ERROR) {
            apn_error_free(&error);
            return 1;
        }
        apn_close(ctx);
        apn_free(&ctx);
        return 0;
    }
    TEST_SCRIPT
    flags = `#{HOMEBREW_PREFIX}/bin/pkg-config --cflags --libs libcapn`.split + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test_install", "test_install.c", *flags
    system "./test_install"
  end
end
