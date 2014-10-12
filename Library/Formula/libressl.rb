require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.0.tar.gz"
  mirror "http://mirrors.nycbug.org/pub/OpenBSD/LibreSSL/libressl-2.1.0.tar.gz"
  sha256 "a32d97b61a98c35f344584b985caf49a3fc3e0e6e24d0bbbbe34fe61dd2627ac"

  bottle do
    sha1 "9b3d8724069c68abd7b287e6bb98038643f4e258" => :mavericks
    sha1 "b4ce593f44fd15ad5e8b98ca3c0ed6b424dc99f0" => :mountain_lion
    sha1 "5fc127e5b5a9bcef3f2a89d532be2f13501ca596" => :lion
  end

  head do
    url "https://github.com/libressl-portable/portable.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflicts with the system OpenSSL."

  def install
    system "./autogen.sh" if build.head?

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
