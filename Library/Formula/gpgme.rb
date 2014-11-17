require "formula"

class Gpgme < Formula
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gpgme1.0/gpgme1.0_1.5.1.orig.tar.bz2"
  sha1 "a91c258e79acf30ec86a667e07f835e5e79342d8"

  bottle do
    sha1 "60d557c728754011a62f4ede0e04ca786bf5b161" => :yosemite
    sha1 "ae98c80946c947f967d44436717ed492b0f08420" => :mavericks
    sha1 "9e3d8a25586683f0aeb050b341b38da79ba770d5" => :mountain_lion
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  fails_with :llvm do
    build 2334
  end

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "tests/gpg/Makefile.in", "GPG = gpg", "GPG = gpg2"
    inreplace "src/gpgme-config.in", "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
    inreplace "src/gpgme-config.in", "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg2", shell_output("#{bin}/gpgme-config --get-gpg").strip
  end
end
