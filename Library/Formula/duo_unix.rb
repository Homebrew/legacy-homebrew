require "formula"

class DuoUnix < Formula
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.6.tar.gz"
  sha1 "02f2d28af55872c278df8b99d2e8503098504583"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}/etc"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{prefix}/etc/login_duo.conf", "-f", "foobar", "echo", "SUCCESS"
  end
end
