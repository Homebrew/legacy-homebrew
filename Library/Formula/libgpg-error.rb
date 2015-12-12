class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.21.tar.bz2"
  sha256 "b7dbdb3cad63a740e9f0c632a1da32d4afdb694ec86c8625c98ea0691713b84d"

  bottle do
    cellar :any
    sha256 "ea4c9a51f1b912f1228a8a57a31d81cf40ecb6dd8ed1702edaac0f648ba2bf10" => :el_capitan
    sha256 "fcdad5e8d38799659050e31fbba673620a9109c3137587cd7e5a01af59582aa2" => :yosemite
    sha256 "4b81f63ec0b8cc947cf10e1183797707b0b144d76de009df6485944075d8d3ff" => :mavericks
    sha256 "e43251953b41cb7fe1ba59f470f11bea647ba74004cc0f82ee3aa3175aca94fb" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
