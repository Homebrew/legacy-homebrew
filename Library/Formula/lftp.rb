class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.4.tar.xz"
  sha256 "1e7cb674c83ace48172263f86847ed04bb6ab2f24116b11a8505f70a15e8805c"

  bottle do
    sha256 "490d37a27d7b1b1ba22109bb3dfb10a21c2d32dc35fe4698e33a852ff239337e" => :el_capitan
    sha256 "7071f8760ce3f738428cd56eee8e1ff430f59de091e4152e4d3693379ef71749" => :yosemite
    sha256 "0ea2e54a7bafd667130b06b56200ec46975b3b30969a649826c3e1ffe2345b50" => :mavericks
    sha256 "4cd518335114f2c29a7514439563f5e2ebe3bff5a24fec1156496f0ae93edd92" => :mountain_lion
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
