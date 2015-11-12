class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "http://pokersource.sourceforge.net"
  url "http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"

  bottle do
    cellar :any
    revision 1
    sha1 "c9296719a25202cc2e285b9424765b323457a074" => :yosemite
    sha1 "80b6927bcbcef1e0c64bed7c57e57ddf0fdef008" => :mavericks
    sha1 "dd113717a5f0dabf6942217b6f48c65d62263755" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
