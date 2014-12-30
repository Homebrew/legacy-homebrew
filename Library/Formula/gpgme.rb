class Gpgme < Formula
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.3.tar.bz2"
  mirror "http://gentoo.tiscali.nl/distfiles/gpgme-1.5.2.tar.bz2"
  mirror "http://sources.buildroot.net/gpgme-1.5.3.tar.bz2"
  sha1 "8dd7711a4de117994fe2d45879ef8a9900d50f6a"

  bottle do
    cellar :any
    sha1 "6acb8e98c8dff9020970439cc69700dc8562ec7f" => :yosemite
    sha1 "1c117231ba66c70b4a8b99d27acba6e704aa078c" => :mavericks
    sha1 "2a8f71ddcb8c0582410bedb5c401057ab1ce990d" => :mountain_lion
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
