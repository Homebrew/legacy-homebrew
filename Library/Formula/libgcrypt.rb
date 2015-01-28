class Libgcrypt < Formula
  homepage "https://gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.2.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libgcrypt/libgcrypt-1.6.2.tar.bz2"
  sha1 "cc31aca87e4a3769cb86884a3f5982b2cc8eb7ec"

  bottle do
    cellar :any
    revision 3
    sha1 "6ff92bb673ffc75595cd1746d3990b3957066580" => :yosemite
    sha1 "95cf78feab0e902da9ca9aee3433b2211254fb0c" => :mavericks
    sha1 "a8c8e6d85ca8dbd30d429ee9c9c50380a7fc0082" => :mountain_lion
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
    system "#{bin}/libgcrypt-config", "--libs"
  end
end
