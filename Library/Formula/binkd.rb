class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "http://binkd.grumbler.org/"
  url "ftp://happy.kiev.ua/pub/fidosoft/mailer/binkd/binkd-1.0.4.tar.gz"
  sha256 "917e45c379bbd1a140d1fe43179a591f1b2ec4004b236d6e0c4680be8f1a0dc0"

  def install
    cp Pathname.glob("mkfls/unix/*").select(&:file?), "."
    inreplace "binkd.conf", "/var/", "/usr/local/var/"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/binkd", "-v"
  end
end
