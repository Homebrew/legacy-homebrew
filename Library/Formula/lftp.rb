require "formula"

class Lftp < Formula
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.5.4.tar.gz"
  sha1 "a2d74b719d0c9a4981e4413e56e3a7a6dda712f7"
  revision 1

  bottle do
    sha1 "927f34e4366934275c26dd3c6166ddd3bfc52bf4" => :mavericks
    sha1 "c34af5bbdb2f7fd606b01279c26a93d0e3d8ba2d" => :mountain_lion
    sha1 "7020a5ebce659a7c50f329070937cb5ff88eddb0" => :lion
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
