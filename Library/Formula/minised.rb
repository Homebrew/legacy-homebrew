class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "http://www.exactcode.de/site/open_source/minised/"
  url "http://dl.exactcode.de/oss/minised/minised-1.15.tar.gz"
  sha256 "ada36a55b71d1f2eb61f2f3b95f112708ce51e69f601bf5ea5d7acb7c21b3481"

  bottle do
    cellar :any
    sha256 "2bb0ccd7cc9ece42928cb5faf945055c9c481844c8c1d154adc0e1c93426aec5" => :yosemite
    sha256 "23edf330523fbc5d05685f94568a396d613619e545ca4ead72536484101c51ca" => :mavericks
    sha256 "623d34f2750f1c5776a0507980e97d3eff9ee63b63ddeb3d7c75e8a4470d4516" => :mountain_lion
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
