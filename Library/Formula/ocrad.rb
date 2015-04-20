require "formula"

class Ocrad < Formula
  homepage "https://www.gnu.org/software/ocrad/"
  url "http://ftpmirror.gnu.org/ocrad/ocrad-0.24.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.24.tar.lz"
  sha1 "b46bbb4b57a3bf2d544cedca47b40f24d8aa811a"

  bottle do
    cellar :any
    sha1 "bc2fb9a7569c50213477ba10f9e40f776f87d318" => :mavericks
    sha1 "e77d6f2d4056e2c47bfef3149afeada4fb7fb047" => :mountain_lion
    sha1 "96f3a02a4eea496f7318eeb97c40a0a7f3505cc3" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    system "#{bin}/ocrad", "-h"
  end
end
