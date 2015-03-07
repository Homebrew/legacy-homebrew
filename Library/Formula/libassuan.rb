class Libassuan < Formula
  homepage "https://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.2.0.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libassuan/libassuan-2.2.0.tar.bz2"
  sha1 "7cf0545955ce414044bb99b871d324753dd7b2e5"

  bottle do
    cellar :any
    sha1 "8c80c50672dff700e0b95f2319b5b3393cc6a00c" => :yosemite
    sha1 "560d930da2edfeaa9e0d6197e83627d15e0be1cb" => :mavericks
    sha1 "adbf32aefee6ef81a73007647ad49818f61416b7" => :mountain_lion
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
