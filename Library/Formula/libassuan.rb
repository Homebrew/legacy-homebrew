require "formula"

class Libassuan < Formula
  homepage "https://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.2.0.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libassuan/libassuan-2.2.0.tar.bz2"
  sha1 "7cf0545955ce414044bb99b871d324753dd7b2e5"

  bottle do
    cellar :any
    sha1 "8c89e123cca5d492535e9ba9ec3ca34141d54823" => :yosemite
    sha1 "b1e6d766da6c4cd4b77ec6d41e3a3ec7d657bd88" => :mavericks
    sha1 "9c395e49e64d3ce487ef36f66dda3c4d6f1f3214" => :mountain_lion
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
