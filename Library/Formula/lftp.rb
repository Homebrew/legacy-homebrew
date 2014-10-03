require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.5.tar.gz"
  sha1 "4dbef2d6a5bd9c44b5571a71a211b639450e09db"

  bottle do
    revision 1
    sha1 "7d82631bdda9733394703049b6a173fa5f4c9cf0" => :mavericks
    sha1 "1056f4a50b53aa43d5d8c4146b306e83936b6400" => :mountain_lion
    sha1 "ccc55f9e4af7325cfbed7ccdbaa78fc3737b34f0" => :lion
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
