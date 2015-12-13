class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.21.tar.bz2"
  sha256 "b7dbdb3cad63a740e9f0c632a1da32d4afdb694ec86c8625c98ea0691713b84d"

  bottle do
    cellar :any
    sha256 "6073da3448cb87c72a9c8db2cda4b9051296ad1a4bee076cd5994eefaf96e874" => :el_capitan
    sha256 "1d608bacb312bf3a3bb32ac55f41d9b5479e1e07711f631141f7db446c7cb99f" => :yosemite
    sha256 "eb0ed3990eb7a231078a99c69d53b72c83d54d1e3bf17fff78cac69804cc9fbe" => :mavericks
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
