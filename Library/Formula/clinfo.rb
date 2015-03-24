class Clinfo < Formula
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.0.15.03.24.tar.gz"
  sha256 "4b2a8a306547024de65bcf496cabe501a05539702aa790e68868039b977bbcaf"

  def install
    system "make"
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    output = shell_output bin/"clinfo"
    assert_match /Device Type +CPU/, output
  end
end
