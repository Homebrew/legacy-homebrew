require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.0.1.tar.gz"
  mirror "http://mirrors.nycbug.org/pub/OpenBSD/LibreSSL/libressl-2.0.1.tar.gz"
  sha256 "9596f6cb3e8bafe35d749dfbdb6c984f1bbd86233598eb5fdb4abf854a5792ba"

  keg_only "LibreSSL is not linked to prevent conflicts with the system OpenSSL."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssldir=#{etc}/libressl",
                          "--with-enginesdir=#{lib}/engines"

    system "make"
    system "make", "check"
    system "make", "install"

    mkdir_p "#{etc}/libressl"
    touch "#{etc}/libressl/openssl.cnf"
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
