class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.2.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.2.1.tar.bz2"
  sha256 "949285bb79345362cb72a40c798defefc007031c60f2f10251720bf60a9de2de"

  bottle do
    cellar :any
    sha256 "082430e5086ace20ca5086e2fefc21135ad88c02043443ea20c0ac8585bc4687" => :yosemite
    sha256 "48898147dc1c848bfa388c73691a3f0695fe01fc0a6371b7650d5d59a5152080" => :mavericks
    sha256 "d27880d342bcfb671a732c94259457df132af396285b5f0728c5a7ac93c79a7e" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/libassuan-config", "--version"
  end
end
