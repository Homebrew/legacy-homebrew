class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "http://ftpmirror.gnu.org/rush/rush-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/rush/rush-1.7.tar.gz"
  sha256 "35077fa36902fd451db52b49bf059992a20cc8ea031437171f384670d77a003a"

  bottle do
    sha256 "37645baa4f7ce9c904e4f62179bef2de7859a77b070c25095c50fca5cd45037c" => :yosemite
    sha256 "17866e573319857967d5e12e32a534ea90845a4ec7568b2d1224032cb6bf8619" => :mavericks
    sha256 "18c1c946892fee725b971f5db26e74da6f1d65686b9df676c329cca6b06a46d0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
