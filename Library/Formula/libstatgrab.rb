class Libstatgrab < Formula
  desc "Provides cross-platform access to statistics about the system."
  homepage "http://www.i-scream.org/libstatgrab/"
  url "http://ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz"
  mirror "https://www.mirrorservice.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz"
  sha256 "03e9328e4857c2c9dcc1b0347724ae4cd741a72ee11acc991784e8ef45b7f1ab"

  bottle do
    cellar :any
    sha256 "5cb49282a895e5b5229a59eedaae8a7ce7517ff6d56dc4837ddbd1601b72eaa9" => :el_capitan
    sha256 "a2175221c61a952b2ed4590c1b5496dcb10d4e9547db4bba8ac69968c2c2a586" => :yosemite
    sha256 "611bd2051960ea32dcc1a814ec93638bd2feb83e76141b715cb47b28d1cc0c92" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/statgrab"
  end
end
