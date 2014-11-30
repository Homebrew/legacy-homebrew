require "formula"

class PcscLite < Formula
  homepage "http://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4126/pcsc-lite-1.8.13.tar.bz2"
  sha1 "baa1ac3a477c336805cdf375912da5cbc8ebab8d"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
