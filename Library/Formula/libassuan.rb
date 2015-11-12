class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.0.tar.bz2"
  sha256 "4d8ce49347fc5443f0a4581488aa80f4ae02920e02608f133f7b9a9283118422"

  bottle do
    cellar :any
    sha256 "be7ca3b1e5d4c70d4ff7fd43b657bc4d0127ac069a8cb14aff4022c326800a13" => :el_capitan
    sha256 "04861a8ccc1eb1abdd90f72dc6460d446c43f69e302217db7d801482797f0943" => :yosemite
    sha256 "25abeb3328bf5c5c156436f74c19ea9e4ecb565f69bc0c5ec5a35373e0aa8c71" => :mavericks
    sha256 "e1cdee9fbe7d6dbadd0e3aea87e935584ae8c1469f7b47e00e462767aef5c195" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    system "#{bin}/libassuan-config", "--version"
  end
end
