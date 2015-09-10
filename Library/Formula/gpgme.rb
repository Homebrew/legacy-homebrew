class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  sha256 "b09de4197ac280b102080e09eaec6211d081efff1963bf7821cf8f4f9916099d"

  bottle do
    cellar :any
    sha256 "7129bc6a4a05b84bdc20474262bd3b932aee25f38fca761977e1d24c3ad45e64" => :yosemite
    sha256 "474f70e432795e77e9d8b28b4bade8582ee6e603bf5f246afa96c3f227dde0c6" => :mavericks
    sha256 "0a4f65a8a21f945e5130dafedeca9e792af7dbf17167bfea030d357027c506ec" => :mountain_lion
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
