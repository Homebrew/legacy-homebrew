class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://gnupg.org/ftp/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  sha256 "6398208394972bbf897c3325780195584682a0d0c164ca5a0da35b93b1e4e7b2"

  bottle do
    cellar :any
    sha256 "cd33dc63963eb71c29a208a16416d231267867d067d15aafe016a8dbe7ec60e7" => :el_capitan
    sha256 "e76de908143691b6b16bbfe434ce83eac919ed0310d989e67c6593bbe1888672" => :yosemite
    sha256 "fc4790c84feeaa7df49810e30ce53b927ce985b839a53809e671464c8ed162ab" => :mavericks
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
