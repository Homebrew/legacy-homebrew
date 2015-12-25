class TaLib < Formula
  desc "Tools for market analysis"
  homepage "http://ta-lib.org/index.html"
  url "https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz"
  sha256 "9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651"

  bottle do
    cellar :any
    revision 1
    sha256 "bb40b6d09be26ee497aae27abea5808730af29e6387fa347996eae49c32c448d" => :yosemite
    sha256 "da1457eb5a09c71f90da185b954aff3d399e61a20ff78ad0bd9d177ad11ad1b7" => :mavericks
    sha256 "d4c5bf3efdaed633acf74d8039d723fd828e52982ebc864a48e09c2e71506311" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system "#{bin}/ta_regtest"
  end
end
