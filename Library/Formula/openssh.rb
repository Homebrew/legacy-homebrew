require "formula"

class Openssh < Formula
  homepage "http://openssh.com"
  url "http://ftp.halifax.rwth-aachen.de/openbsd/OpenSSH/portable/openssh-6.5p1.tar.gz"
  sha1 "3363a72b4fee91b29cf2024ff633c17f6cd2f86d"
  version "6.5p1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ssh", "-V"
  end
end
