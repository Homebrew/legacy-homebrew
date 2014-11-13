require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.1.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.1.1.tar.gz"
  sha256 "fb5ada41a75b31c8dd9ff013daca57b253047ad14e43f65d8b41879b7b8e3c17"

  bottle do
    revision 1
    sha1 "0dfcc9750a6814d8752ccccb00b13fc016fdc208" => :yosemite
    sha1 "70d1033f5248bbb7fb77c041e951aeb005cc654d" => :mavericks
    sha1 "76dad0e3ff301c545b3436c05ba144d7c2d59904" => :mountain_lion
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
