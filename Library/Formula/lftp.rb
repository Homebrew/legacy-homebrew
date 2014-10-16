require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.0.tar.gz"
  sha1 "8bc43080c3c467d1aeb659382d95ef5ac7436504"

  bottle do
    sha1 "57279f43658740d7e87023047e475892ea0516a2" => :mavericks
    sha1 "252a3be94362178b6de0eb8dae476b412db8c7e1" => :mountain_lion
    sha1 "e791cfe2173d7ba26392e313d423b98212a7b2d3" => :lion
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
