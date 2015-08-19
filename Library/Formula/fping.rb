class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "http://fping.org/"
  url "http://fping.org/dist/fping-3.10.tar.gz"
  sha256 "cd47e842f32fe6aa72369d8a0e3545f7c137bb019e66f47379dc70febad357d8"

  head "https://github.com/schweikert/fping.git"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--enable-ipv6"
    system "make", "install"
  end
end
