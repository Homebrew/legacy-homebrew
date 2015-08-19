class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.3a.tar.xz"
  sha256 "8c3a12a1f9ec288132b245bdd7d14d88ade1aa5cb1c14bb68c8fab3b68793840"

  bottle do
    sha256 "5f939d210823658f99f455b76250aac59e4db8a02673f3ec69087cf4a61ea20b" => :yosemite
    sha256 "d5f13cc616fb5d3346fc83a15ec3c6185e00aba6964c6c755b520b1f8367a973" => :mavericks
    sha256 "7ad557cfbebbe54ac6e7c017aa183752b6ae9bbf9939231b2a403feaf297be6b" => :mountain_lion
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
