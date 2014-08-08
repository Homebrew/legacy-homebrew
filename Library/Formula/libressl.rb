require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.0.5.tar.gz"
  mirror "http://mirrors.nycbug.org/pub/OpenBSD/LibreSSL/libressl-2.0.5.tar.gz"
  sha256 "3f5463b5deb93efd2ac4e23a20612a1ccf3299a569d03880bb204c90647dfc9a"

  bottle do
    sha1 "2dd99197be9c8b3b398957d27c644fd013f20872" => :mavericks
    sha1 "cac9b95d478f758adbe068c229340060873b77d0" => :mountain_lion
    sha1 "d4ea342023e74362c3dc766f618727177df63424" => :lion
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
