require "formula"

class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.0.2.tar.gz"
  mirror "http://mirrors.nycbug.org/pub/OpenBSD/LibreSSL/libressl-2.0.2.tar.gz"
  sha256 "4d16b6852cbd895ed55737819d2c042b37371f1d80fcba4fb24239eba2a5d72b"

  bottle do
    sha1 "e8bcd127c027227d2ea5f1fef2172187d957706e" => :mavericks
    sha1 "98717ba0aba142be6aaf079d84b6e011dd0424c8" => :mountain_lion
    sha1 "ab6912d5fb3696797ff6178a286896e1a9a252d2" => :lion
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
