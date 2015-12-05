class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.2.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.2.tar.bz2"
  sha256 "bb06dc81380b74bf1b64d5849be5c0409a336f3b4c45f20ac688e86d1b5bcb20"

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
