class Gpgme < Formula
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gpgme1.0/gpgme1.0_1.5.1.orig.tar.bz2"
  sha1 "a91c258e79acf30ec86a667e07f835e5e79342d8"

  bottle do
    cellar :any
    sha1 "6acb8e98c8dff9020970439cc69700dc8562ec7f" => :yosemite
    sha1 "1c117231ba66c70b4a8b99d27acba6e704aa078c" => :mavericks
    sha1 "2a8f71ddcb8c0582410bedb5c401057ab1ce990d" => :mountain_lion
  end

  option "with-gnupg2", "Build with gnupg 2.0.x"
  option "with-gnupg21", "Build with gnupg 2.1.x"

  depends_on "gnupg2" => :recommended
  depends_on "gnupg21" => :optional
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  fails_with :llvm do
    build 2334
  end

  def install
    if build.with? "gnupg2" and build.with? "gnupg21"
      ohai <<-EOS.undent
      --with-gnupg2 and --with-gnupg21 are both specified and
      gpgme can only use one at a time; proceeding with gnupg2.
      EOS
    end

    if build.with? "gnupg2"
      # Check these inreplaces with each release.
      # At some point GnuPG will pull the trigger on moving to GPG2 by default.
      inreplace "tests/gpg/Makefile.in", "GPG = gpg", "GPG = gpg2"
      inreplace "src/gpgme-config.in", "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
      inreplace "src/gpgme-config.in", "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"
    end

    if build.with? "gnupg21"
      # Check these inreplaces with each release.
      # At some point GnuPG will pull the trigger on moving to GPG2 by default.
      inreplace "tests/gpg/Makefile.in", "GPG = gpg", "GPG = gpg2"
      inreplace "src/gpgme-config.in", "@GPG@", "#{Formula["gnupg21"].opt_prefix}/bin/gpg2"
      inreplace "src/gpgme-config.in", "@GPGSM@", "#{Formula["gnupg21"].opt_prefix}/bin/gpgsm"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    if build.with? "gnupg2"
      assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg2", shell_output("#{bin}/gpgme-config --get-gpg").strip
    end
    if build.with? "gnupg21"
      assert_equal "#{Formula["gnupg21"].opt_prefix}/bin/gpg2", shell_output("#{bin}/gpgme-config --get-gpg").strip
    end
  end
end
