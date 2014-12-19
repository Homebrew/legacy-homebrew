require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.0.tar.gz"
  sha1 "8bc43080c3c467d1aeb659382d95ef5ac7436504"

  bottle do
    sha1 "87b4743143c4e28acb8f5b41640aeb5e914d2401" => :mavericks
    sha1 "3b5b583e2c72963730f58124b73e5d237fbbb2ba" => :mountain_lion
    sha1 "f407aa7c77b33e26edab841aa84fa6050248a0f0" => :lion
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
