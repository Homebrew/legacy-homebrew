class Pinentry < Formula
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.1.tar.bz2"
  sha256 "9cd08e856b395df3adc7124170b53f77c6d5c8bf88e899e818648ec70d3e9695"

  bottle do
    cellar :any
    sha256 "05b031f893d61712d5de8c257ef8a887d000671504b8ee7845fb179f4d25ccee" => :yosemite
    sha256 "f2de1987355b73d291fd5ddabd3e86a06124da57a97d77284dac65df973b29ba" => :mavericks
    sha256 "509a5697d2d15e4c3bbda536bd514987fca941cf367fa7b6de0dd9877276cebc" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk2"
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
