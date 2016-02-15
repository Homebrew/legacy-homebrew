class Binkd < Formula
  desc "TCP/IP FTN Mailer"
  homepage "http://binkd.grumbler.org/"
  url "ftp://happy.kiev.ua/pub/fidosoft/mailer/binkd/binkd-1.0.4.tar.gz"
  sha256 "917e45c379bbd1a140d1fe43179a591f1b2ec4004b236d6e0c4680be8f1a0dc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e28861a7cae55e86386be5ed5147960addf54369b51d97e83f3fc0e0d96656d2" => :el_capitan
    sha256 "095ca49907d9dc5ace8cdb488278d9a8e7aad90cbda88d8424da0a1474c758d4" => :yosemite
    sha256 "63d9497071231849a387aaf2496a9f16ff98c8b65b9343e2dd67d0075c7997e2" => :mavericks
  end

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    inreplace "binkd.conf", "/var/", "#{var}/"
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
