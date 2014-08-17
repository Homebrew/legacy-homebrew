require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.4.tar.gz"
  sha1 "a2d74b719d0c9a4981e4413e56e3a7a6dda712f7"

  bottle do
    sha1 "111140bb3894bae5e2c550ffb7acff6eebe24c76" => :mavericks
    sha1 "f4043184123f0bc74c72465e6a37d91aea3265d3" => :mountain_lion
    sha1 "1a6109bc615185c10cac5fdedb0d8583371b5884" => :lion
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
