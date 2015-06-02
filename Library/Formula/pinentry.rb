class Pinentry < Formula
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.3.tar.bz2"
  sha256 "88c2d9ff892d591c2a12c52229eb2262f0ae4b8e58b551990a0949f44df98244"

  bottle do
    cellar :any
    sha256 "5369b65160510af92db399df25f5b6a2d4cb0f774aea1411fb6f8ea5384ac661" => :yosemite
    sha256 "1914fbeb2bfc59d18b98a891d3dd8afe5522a41ada4d8dfec141ffed844c7d76" => :mavericks
    sha256 "924d8f93a0c96b957882bb6a8ad4614a7dd20471a89b8ee14ad273aa53d7c9fb" => :mountain_lion
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
