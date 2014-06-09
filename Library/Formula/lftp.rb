require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.1.tar.xz"
  sha1 "a9463b70a55ef609bc36f1af42a6189c7467daf5"

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
