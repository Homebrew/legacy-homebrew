class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/index.en.html"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.3.0.tar.bz2"
  mirror "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.3.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.3.0.tar.bz2"
  sha256 "87c999f572047fa22a79ab5de4c8a1a5a91f292561b69573965cac7751320452"

  bottle do
    cellar :any
    sha256 "9a5ac608a3322662a856fffd767d32f73280efaa669db40986cb4afe99b54a53" => :yosemite
    sha256 "a3fa154b7e71d01c075eabe3c4ca734b41fe16a0def4a58ee4b86baedf6c870e" => :mavericks
    sha256 "813f56f29c5980e29c4be3af94ed2310b1d81804a7f42636c634e0ef0b6da99d" => :mountain_lion
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
