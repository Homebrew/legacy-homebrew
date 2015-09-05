class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/"
  url "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2"
  mirror "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2"
  sha256 "3266895ce3419a7fb093e63e95e2ee3056c481a9bc0d6df694cfd26f74e72522"

  bottle do
    cellar :any
    sha256 "36c61b2d6a46ec5e8d4bc5d0bf80e652e0d7180c21f75bed7fc87b6793344e85" => :yosemite
    sha256 "225b260d5c3e622c9ab1538e8642d10b62b57282f9aadf4a3cb02dc6a4f25be0" => :mavericks
    sha256 "ce481b620a112a18602c2d764f0293629ffa8fdd332f1a149e9271dd6b69293b" => :mountain_lion
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
