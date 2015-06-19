class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.19.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.19.tar.bz2"
  sha256 "53120e1333d5c5d28d87ff2854e9e98719c8e214152f17ad5291704d25c4978b"

  bottle do
    cellar :any
    sha256 "d5d119f2cfa0172ef20a05fee0ebb9746f5cb26b51e28d7a8a2e25c6398bca6a" => :yosemite
    sha256 "78f175ed5ecf1b846bd7819b9110823ee615f31a29a8a9f4443143d6fcaece34" => :mavericks
    sha256 "d20fac5b6d68c489bd2dfcaaf2d2ea9b2767efbc510b89f6426c402281007c5b" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
