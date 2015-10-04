class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4138/pcsc-lite-1.8.14.tar.bz2"
  sha256 "b91f97806042315a41f005e69529cb968621f73f2ddfbd1380111a175b02334e"

  bottle do
    sha256 "e8320de38e77f4f61a32a0128656fe8a59b1f687f100b9aa52fb231b56ca7813" => :yosemite
    sha256 "362bd1206703cc34486792493e2f1a5179acdf9c7a4652cb34ea0f63ff87495f" => :mavericks
    sha256 "9bc9f64b8299ca9e445402d6b249490719901501ce01a8ffc66207519de7615c" => :mountain_lion
  end

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
