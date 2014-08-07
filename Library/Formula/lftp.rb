require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.4.tar.gz"
  sha1 "a2d74b719d0c9a4981e4413e56e3a7a6dda712f7"

  bottle do
    sha1 "e77c6a4db177a1d57d4d64a26c0695f04458ce70" => :mavericks
    sha1 "fae24a8f755a8a35a41059b78da9c12567659b61" => :mountain_lion
    sha1 "9d9f72624246af050ef7131697d21874f487a8a7" => :lion
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
