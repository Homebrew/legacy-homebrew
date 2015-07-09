class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.5.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pinentry/pinentry_0.9.5.orig.tar.bz2"
  sha256 "6a57fd3afc0d8aaa5599ffcb3ea4e7c42c113a181e8870122203ea018384688c"

  bottle do
    cellar :any
    revision 1
    sha256 "d6caa258ee85016f4eae79c6ee42745f0b3f16d6572c8eebc5be7a70384184d3" => :yosemite
    sha256 "772335dcc0286d88679240a68fca2555fbb347917f2a1c54e07f4afe9858fbda" => :mavericks
    sha256 "9f7ad30cddaaf46eb49e781b82a95200679e0d93274f33b81e270421db00b9f6" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk2",
                          "--disable-pinentry-gnome3"
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
