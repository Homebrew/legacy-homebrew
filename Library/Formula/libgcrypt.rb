class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  sha1 "9456e7b64db9df8360a1407a38c8c958da80bbf1"

  bottle do
    cellar :any
    sha1 "d24142fb501c015dc669d9c0a8d94c5dc7123ee0" => :yosemite
    sha1 "1ca2c47570a91ffe6e6c96a6d50627a8cce1e58e" => :mavericks
    sha1 "3bf6ac3f6bc55a8fbd51b3fc9d7fd6677469d14e" => :mountain_lion
  end

  depends_on "libgpg-error"

  option :universal

  resource "config.h.ed" do
    url "http://trac.macports.org/export/113198/trunk/dports/devel/libgcrypt/files/config.h.ed"
    version "113198"
    sha1 "136f636673b5c9d040f8a55f59b430b0f1c97d7a"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    # Parallel builds work, but only when run as separate steps
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"libgcrypt-config", "--libs"
  end
end
