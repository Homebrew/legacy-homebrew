require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.3.tar.gz"
  sha1 "7c70d2b428c071fc19dd340bcd5bf04069b5fad0"

  bottle do
    sha1 "7c451feb5c89c7d51b2d4095477a5033d0baf2e7" => :mavericks
    sha1 "4f9445f0673a5c8a5235fdfaaf266e109a3be050" => :mountain_lion
    sha1 "240b0b9efbeab3473a9892353e31246bf0fef0dc" => :lion
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
