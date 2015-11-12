class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.0.tar.bz2"
  sha256 "4d8ce49347fc5443f0a4581488aa80f4ae02920e02608f133f7b9a9283118422"

  bottle do
    cellar :any
    sha256 "98a2e92cc72b5614af2a9b73712f46eaed09bd1a7cb125c2896500919930c4a8" => :el_capitan
    sha256 "4a4502c82bdebbe5f355d585ce2b8d82e44ea30f7b753c108b5e71ac4f149a1a" => :yosemite
    sha256 "c4800f985a9357ab1cfeb2d6461c1b4012f76e619266e0ebfb82aa822a5da8c1" => :mavericks
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
