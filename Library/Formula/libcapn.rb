require 'formula'

class Libcapn < Formula
  homepage 'http://libcapn.org/'
  url 'http://libcapn.org/download/libcapn-1.0.0b3-src.tar.gz'
  sha1 'a53f7b382e683249ff55214b1effbae5f82c4ef2'
  head 'https://github.com/adobkin/libcapn.git'

  bottle do
    cellar :any
    sha1 "afde01eeff054cb43b1b6f07aac57fd7d64d7ff3" => :mavericks
    sha1 "36dd5a2dca57ccf642a34b7e5da55425005e2575" => :mountain_lion
    sha1 "3d4a2895efd4054d73152b7f5b193ef1773d1eaf" => :lion
  end

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

    flags = ["-I#{include}/capn", "-L#{lib}/capn", "-lcapn"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test_install", "test_install.c", *flags
    system "./test_install"
  end
end
