require "formula"

class Xorriso < Formula
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.3.8.tar.gz"
  sha1 "e16757413ad06f3295b27d30e5a3604bd8c2c606"

  bottle do
    cellar :any
    sha1 "ad77fd89af5dfb762f5a090bda81e879961e2cd3" => :mavericks
    sha1 "9a13f8d21424c8c1916c18942d4c2466a853a83a" => :mountain_lion
    sha1 "59061ff18ad511c667654fee742db83bdbcc87f0" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end
