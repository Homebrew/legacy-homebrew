require 'formula'

class Openssl < Formula
  homepage 'http://openssl.org'
  url 'https://www.openssl.org/source/openssl-1.0.1g.tar.gz'
  mirror 'http://mirrors.ibiblio.org/openssl/source/openssl-1.0.1g.tar.gz'
  sha256 '53cb818c3b90e507a8348f4f5eaedb05d8bfe5358aabb508b7263cc670c3e028'
  revision 1

  bottle do
    sha1 "d8c38bb2fe4dfd8930ea02f87d4b958a2a33b051" => :mavericks
    sha1 "536d1e6bd5e1321eb603b4ed1ad131ea86a2794c" => :mountain_lion
    sha1 "f12f352e67e5b131c1935040f8d2ca24107ebfca" => :lion
  end

  depends_on "makedepend" => :build if MacOS.prefer_64_bit?

  keg_only :provided_by_osx,
    "The OpenSSL provided by OS X is too old for some software."

  # OpenBSD 5.4 errata 8, Apr 12, 2014:  A use-after-free race condition
  # in OpenSSL's read buffer may permit an attacker to inject data from
  # one connection into another.
  patch do
    url "http://ftp.openbsd.org/pub/OpenBSD/patches/5.4/common/008_openssl.patch"
    sha1 "ede490c6f3eb76f0b085bce76506c2661ab2707e"
  end

  def install
    args = %W[./Configure
               --prefix=#{prefix}
               --openssldir=#{openssldir}
               zlib-dynamic
               shared
               enable-cms
             ]

    if MacOS.prefer_64_bit?
      args << "darwin64-x86_64-cc" << "enable-ec_nistp_64_gcc_128"
    else
      args << "darwin-i386-cc"
    end

    system "perl", *args

    ENV.deparallelize
    system "make", "depend" if MacOS.prefer_64_bit?
    system "make"
    system "make", "test"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl"
  end

  def cert_pem
    openssldir/"cert.pem"
  end

  def osx_cert_pem
    openssldir/"osx_cert.pem"
  end

  def write_pem_file
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    osx_cert_pem.atomic_write `security find-certificate -a -p #{keychains.join(" ")}`
  end

  def post_install
    openssldir.mkpath

    if cert_pem.exist?
      write_pem_file
    else
      cert_pem.unlink if cert_pem.symlink?
      write_pem_file
      openssldir.install_symlink 'osx_cert.pem' => 'cert.pem'
    end
  end

  test do
    (testpath/'testfile.txt').write("This is a test file")
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32"
    system "#{bin}/openssl", 'dgst', '-sha1', '-out', 'checksum.txt', 'testfile.txt'
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
