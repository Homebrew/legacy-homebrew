class Libksba < Formula
  homepage "https://www.gnupg.org/related_software/libksba/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
  sha256 "0c7f5ffe34d0414f6951d9880a46fcc2985c487f7c36369b9f11ad41131c7786"

  bottle do
    cellar :any
    sha1 "d7ad259546f648c7187b0d213df2d747267affff" => :yosemite
    sha1 "fb1657abc91ef16076fe005b42f77d0a67ab849f" => :mavericks
    sha1 "f0a2bd05b9cb065384230ed3c2054af847ce4b67" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
