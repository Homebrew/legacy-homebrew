require "formula"

class Clamav < Formula
  homepage "http://www.clamav.net/"
  head "https://github.com/vrtadmin/clamav-devel"
  url "https://downloads.sourceforge.net/clamav/clamav-0.98.4.tar.gz"
  sha1 "f1003d04f34efb0aede05395d3c7cc22c944e4ef"

  bottle do
    revision 1
    sha1 "3cec3e85844d54a629a735a4cd035475af1a62b4" => :mavericks
    sha1 "2f7e1f591e956369eae6446e4a5aeb4ee79940e4" => :mountain_lion
    sha1 "07e9159ecbf0aa90dd56a7ee9d728b7bb77d5b6b" => :lion
  end

  depends_on "openssl"

  skip_clean "share/clamav"

  def install
    (share/"clamav").mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--sysconfdir=#{etc}",
                          "--disable-zlib-vcheck",
                          "--with-zlib=#{MacOS.sdk_path}/usr",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end
end
