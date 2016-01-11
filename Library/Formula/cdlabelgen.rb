class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "http://www.aczoom.com/tools/cdinsert/"
  url "http://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"

  bottle do
    cellar :any_skip_relocation
    sha256 "34758541efaf3e124ff531d09cdf3f511651be8602f179de1e5ecd606b0aa60b" => :el_capitan
    sha256 "caeda225b0c542c388723e7ac464844d8924705e14313a1665526564d3bb12bc" => :yosemite
    sha256 "bf49f61ddb7f79e9699bfca3e0867b5869359be85de43184b77abadece71a645" => :mavericks
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system "#{bin}/cdlabelgen", "-c", "TestTitle", "--output-file", "testout.eps"
    File.file?("testout.eps")
  end
end
