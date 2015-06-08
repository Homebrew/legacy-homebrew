class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.5.tar.bz2"
  sha256 "0b3d3d5107680c594777aae65882a1ff6dd1ba629a83432e719c8b82a743c207"

  bottle do
    cellar :any
    sha256 "c7e8c677f15c257f3165ce1f10d4a9d9abd2b4a42d713475860c410fcf766d74" => :yosemite
    sha256 "6af7970311db4ac67c5ff6c2931c0326214dc42f0a85e663cf132d9d9041833b" => :mavericks
    sha256 "053e7760f0bc4310452c25c6979e06dd05f8f4143bccad0eaa0db4ba914532b4" => :mountain_lion
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
