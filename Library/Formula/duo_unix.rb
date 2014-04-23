require "formula"

class DuoUnix < Formula
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.9.10.tar.gz"
  sha1 "13977071bdcb24b5d9de13e4fe1a973d60885b37"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf", "-f", "foobar", "echo", "SUCCESS"
  end
end
