class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/"
  url "https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.6.4.tar.bz2"
  mirror "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.4.tar.bz2"
  sha256 "c9bc2c7fe2e5f4ea13b0c74f9d24bcbb1ad889bb39297d8082aebf23f4336026"

  bottle do
    cellar :any
    sha256 "c239866860860e717e646856b9870e7cd9ee0729b8700a40f8be47a174d29146" => :el_capitan
    sha256 "e8559d5c93be44c94a4652f74d8835a416b1771e492446c2a2d9da725460d5ca" => :yosemite
    sha256 "09a01dd58c81f0efb278d2e1270983ae4e477bb5fc4c54489dc6582084a147bb" => :mavericks
    sha256 "1c79948cbb7bb2750f23a6b3a91aafbd49ef0eb4d5868cabd91dcfb7592dac19" => :mountain_lion
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
    system "make", "install"
    # Make check currently dies on El Capitan
    # https://github.com/Homebrew/homebrew/issues/41599
    # https://bugs.gnupg.org/gnupg/issue2056
    # This check should be above make install again when fixed.
    system "make", "check"
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match /0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6/, output
  end
end
