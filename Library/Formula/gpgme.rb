class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  sha256 "b09de4197ac280b102080e09eaec6211d081efff1963bf7821cf8f4f9916099d"

  bottle do
    cellar :any
    sha256 "81b2d72d94b9eaceeefb68939fa9f390fea9f1253cb81af5201e3ced06232a22" => :el_capitan
    sha256 "73a8ec1c22d57bec7f1bb129f32b1597831f67a9b1a1763588f938f9a65e3fde" => :yosemite
    sha256 "9541c704ace2a3ca7abdcf4325a28377bff3845998fa4fd61c464f642e88e3e4" => :mavericks
    sha256 "6a28a7847a908c2ca93e88255acab792007bb7dbb4387ff897498d74f43650d5" => :mountain_lion
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  conflicts_with "argp-standalone",
                 :because => "gpgme picks it up during compile & fails to build"

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
