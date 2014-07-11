require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.0.0.tar.gz"
  sha1 "c078e98f86bb37dca8340ab17bc1efd8620c3286"

  option "without-check", "Skip build-time tests (not recommended)"

  keg_only "LibreSSL is not linked to prevent conflicts with OS X's OpenSSL."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32"
    system "#{bin}/openssl", "dgst", "-sha1", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
