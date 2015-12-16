class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "http://libcapn.org/"
  url "http://libcapn.org/download/libcapn-1.0.0-src.tar.gz"
  sha256 "2c80b3adedf8e2250c6e4d3047998903b8efc7af018032ed04b712158ea02983"
  head "https://github.com/adobkin/libcapn.git"

  bottle do
    cellar :any
    sha256 "09cbbfc8fb5037b3ec0c5ef70e79dbbf47370fb382284857ea333c3459179f9f" => :yosemite
    sha256 "1113b788db1d53843e20693d668f5847957c04c83eefb14da41bf57778e61f48" => :mavericks
    sha256 "eb99972edf809a3d2ea12c56bd7461574f4a108565e9ad75e1341cbf846f2b80" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test_install.c").write <<-TEST_SCRIPT.undent
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
