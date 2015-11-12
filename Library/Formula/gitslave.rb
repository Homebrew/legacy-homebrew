class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "http://gitslave.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
