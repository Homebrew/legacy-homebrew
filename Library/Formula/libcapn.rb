require 'formula'

class Libcapn < Formula
  homepage 'http://libcapn.org/'
  url "http://libcapn.org/download/libcapn-1.0.0-src.tar.gz"
  sha1 "740dc87395fc7255b78c3c926a044f00692e8c41"
  head 'https://github.com/adobkin/libcapn.git'

  bottle do
    cellar :any
    revision 1
    sha1 "43623277454738f652a5034249cd55581f3f166a" => :yosemite
    sha1 "d36a220fa7a66a0f5218442a312f9cde8d6da2d1" => :mavericks
    sha1 "c93311bffc8ede6384df303c1c37aaff6dd73acf" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on "openssl"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "cmake", ".", *cmake_args
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
