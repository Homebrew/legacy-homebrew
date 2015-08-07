class Lzo < Formula
  desc "Real-time data compression library"
  homepage "http://www.oberhumer.com/opensource/lzo/"
  url "http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
  sha256 "f294a7ced313063c057c504257f437c8335c41bfeed23531ee4e6a2b87bcb34c"

  bottle do
    cellar :any
    sha256 "27ec3d9e9303bab8aedb74eb617b147f92e34251c0a3da2fba9004f3d76ea96f" => :yosemite
    sha256 "af6941abe4f2a8db33e5a8296352b4cf0ef4df73152e8f968efa59b7213a5969" => :mavericks
    sha256 "d9ccb8e665598254f96907a1716760af99736771f41be2f31ab47c6409017251" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
