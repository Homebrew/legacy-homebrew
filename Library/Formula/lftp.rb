require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.1.tar.gz"
  sha1 "57b62d7365de1698433a3b1b5daf7192adc2517a"

  bottle do
    sha1 "4eb97a364cce3e0af57a0fb08e7b8094bf3fa5f5" => :yosemite
    sha1 "331af6459f1cd2c65c4845cdaf0c2bd0e475e2e1" => :mavericks
    sha1 "0ebecf5a39e1a5a6cdd4da9405b0914470c72e87" => :mountain_lion
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
