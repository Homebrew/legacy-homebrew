require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.2.tar.xz"
  sha1 "c87b893852900d8e16556fac7305bdb25febfb7c"

  bottle do
    sha1 "ffc1063e8d6ba436e3660eda4fb51c5f07918259" => :mavericks
    sha1 "13564b089c9f20323dd9c095932bf55d571daf8b" => :mountain_lion
    sha1 "e75facd37483ec5064ca363b834eebc905772970" => :lion
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
end
