class Pinentry < Formula
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.3.tar.bz2"
  sha256 "88c2d9ff892d591c2a12c52229eb2262f0ae4b8e58b551990a0949f44df98244"

  bottle do
    cellar :any
    sha256 "4cb0a5a49787d34b3ab201b0d7d7e04bf9c2997ecd9acfa317bf4e5515414316" => :yosemite
    sha256 "ce8ef66a0b5860788b8f317a68d0d10206394a02c71c8d43600a528226e13e76" => :mavericks
    sha256 "3ee6b0dad415740e56b0446935121c3ecf4379a0b1bc85bd67d20afbb1224b27" => :mountain_lion
  end

  depends_on "pkg-config" => :build

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
