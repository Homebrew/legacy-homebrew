require "formula"

class DuoUnix < Formula
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.13.tar.gz"
  sha1 "96120910cbaa75c3a59e4c12006738b267c3e9f0"
  revision 1

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf", "-f", "foobar", "echo", "SUCCESS"
  end
end
