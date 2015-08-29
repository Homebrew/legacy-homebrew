class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/"
  url "https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  mirror "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.3.tar.bz2"
  sha256 "41b4917b93ae34c6a0e2127378d7a4d66d805a2a86a09911d4f9bd871db7025f"
  revision 2

  bottle do
    cellar :any
    sha256 "5b91dcf0792864e4e99e4b98aaf77059a774413a69a6c928464a14423b818203" => :yosemite
    sha256 "fe40a4fe7207e304ea37cad4ed79adcd12a60afd1ec8e3df7cf84f2b74112250" => :mavericks
    sha256 "9b8e3eb1b725902b4212a450370fbeda75f71de46768cb76240fb0a7c11d2eba" => :mountain_lion
  end

  option :universal

  depends_on "libgpg-error"

  resource "config.h.ed" do
    url "https://raw.githubusercontent.com/DomT4/scripts/4d0517f86/Homebrew_Resources/MacPorts_Import/libgcrypt/r113198/config.h.ed"
    mirror "https://trac.macports.org/export/113198/trunk/dports/devel/libgcrypt/files/config.h.ed"
    version "113198"
    sha256 "d02340651b18090f3df9eed47a4d84bed703103131378e1e493c26d7d0c7aab1"
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
    # Make check currently dies on El Capitan
    # https://github.com/Homebrew/homebrew/issues/41599
    # https://bugs.gnupg.org/gnupg/issue2056
    system "make", "check" unless MacOS.version >= :el_capitan
    system "make", "install"
  end

  test do
    system bin/"libgcrypt-config", "--libs"
  end
end
