class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.4.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.4.0.tar.gz"
  sha256 "0bd1e085015b28c24f57697d6def2fe84517967dc417554c0c3ccf1685ed0e56"

  bottle do
    cellar :any
    sha256 "99291dcf6826ec15b82c9d32ddae8279244f304661f23e1086f69392ce14f34c" => :yosemite
    sha256 "611ac7bb03593af3216d772b0d4d0b3b5797257dd656b3eb04db3da0f7582f7d" => :mavericks
    sha256 "88442ed4676b021a09bafeef4cd3b40a7e822bb7b4239a1de0518360eefbd5a6" => :mountain_lion
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
