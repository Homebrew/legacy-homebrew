class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "http://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftp.gnu.org/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"

  bottle do
    cellar :any
    revision 1
    sha1 "883a10b3f456d9ac39ca1442253a90167157b50c" => :yosemite
    sha1 "b7d2b8c174df9ac8b9e77aada7efe2e94384a913" => :mavericks
    sha1 "d21c5eb24647aa5d18f589ab4327c215df6383f6" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
