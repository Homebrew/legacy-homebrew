require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.5.tar.gz"
  sha1 "4dbef2d6a5bd9c44b5571a71a211b639450e09db"

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
end
