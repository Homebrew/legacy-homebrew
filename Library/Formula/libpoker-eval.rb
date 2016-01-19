class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "http://pokersource.sourceforge.net"
  url "http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"

  bottle do
    cellar :any
    revision 1
    sha256 "b15086546ac1ac0310e3113231bfcc2c9de0d23474be8a1a1b4663e6bc8f713f" => :yosemite
    sha256 "9bbfb3886a4e530455dbf53581aecd0df8c86a2f80a444692441449c30f76d92" => :mavericks
    sha256 "32281cedd42b9a1a99ff146ad97f00ae682f75249f7e16166ab8bd4ca0378e31" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
