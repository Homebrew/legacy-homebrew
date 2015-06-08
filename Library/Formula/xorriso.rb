class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.4.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.4.0.tar.gz"
  sha256 "0bd1e085015b28c24f57697d6def2fe84517967dc417554c0c3ccf1685ed0e56"

  bottle do
    cellar :any
    sha1 "ad77fd89af5dfb762f5a090bda81e879961e2cd3" => :mavericks
    sha1 "9a13f8d21424c8c1916c18942d4c2466a853a83a" => :mountain_lion
    sha1 "59061ff18ad511c667654fee742db83bdbcc87f0" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end
