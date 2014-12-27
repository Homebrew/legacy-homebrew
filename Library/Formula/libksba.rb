class Libksba < Formula
  homepage "http://www.gnupg.org/related_software/libksba/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.2.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.2.tar.bz2"
  sha1 "37d0893a587354af2b6e49f6ae701ca84f52da67"

  bottle do
    cellar :any
    sha1 "d7ad259546f648c7187b0d213df2d747267affff" => :yosemite
    sha1 "fb1657abc91ef16076fe005b42f77d0a67ab849f" => :mavericks
    sha1 "f0a2bd05b9cb065384230ed3c2054af847ce4b67" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
