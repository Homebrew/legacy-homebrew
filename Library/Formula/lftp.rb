require "formula"

class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.2.tar.gz"
  sha1 "8c50f1b4c721143ac3e3428a72c9864edfde61f6"

  bottle do
    sha256 "725145ef258d9a536bd78e7bab9c31ff1a5ae1f8d6c3ec86aa52dc6e0948e3b7" => :yosemite
    sha256 "6980ddc42aa5e021a3f5d0f2e06b2613151b9972390b077f34ed765b30d28c81" => :mavericks
    sha256 "40aa62dc70760f0cca86c3cbd52da7392c0aa118c48877aa3df4ca7258b1ba03" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://mirrors.kernel.org; ls"
  end
end
