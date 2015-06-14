require "formula"

class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz"
  sha256 "6c9f6756bc43bc225b842f7e3a0ec7204e0cf606e10559d27704e1cc33098c9a"

  bottle do
    cellar :any
    sha1 "057993febf5b5b02d022e0b1a1b1e6d9dcee1702" => :mavericks
    sha1 "41b83f3a61169a73e3ce5c73f0c8f533dbf8161c" => :mountain_lion
    sha1 "a84965928a810a18f8dbac38091e4ab9a9e69214" => :lion
  end

  depends_on "xz" => :optional
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end
end
