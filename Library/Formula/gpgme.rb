class Gpgme < Formula
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.3.tar.bz2"
  mirror "ftp://mirror.switch.ch/mirror/gnupg/gpgme/gpgme-1.5.3.tar.bz2"
  mirror "http://sources.buildroot.net/gpgme-1.5.3.tar.bz2"
  sha1 "8dd7711a4de117994fe2d45879ef8a9900d50f6a"

  bottle do
    cellar :any
    sha1 "61785471d163d15cef924d11a9e4623cbe4126f6" => :yosemite
    sha1 "65581c685595865411af4bc530e5bfe4ee7929b6" => :mavericks
    sha1 "411d0b43ee5e2906fb08742d02a9f167dd0bb33a" => :mountain_lion
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
