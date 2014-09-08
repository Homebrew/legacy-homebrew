require "formula"

class DuoUnix < Formula
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.11.tar.gz"
  sha1 "4cb4e585b69fbc6a0a3635bc241fa22653c2f9c4"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf", "-f", "foobar", "echo", "SUCCESS"
  end
end
