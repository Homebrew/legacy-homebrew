class Nrg2iso < Formula
  desc "Extract ISO9660 data from Nero nrg files"
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz"
  sha256 "25049d864680ec12bbe31b20597ce8c1ba3a4fe7a7f11e25742b83e2fda94aa3"

  bottle do
    cellar :any
    sha256 "18949f41b9ba386c996a49541875d3320184b88dccb04136846f32b3d681e647" => :yosemite
    sha256 "a46624bc9fc5f7883e923920dbc96aef720e5bb37b4ac71a281d101b96decee6" => :mavericks
    sha256 "7ae80a678e7641b6b7838aac679caad0c5c2213f068c1141e8b8cb01539babb3" => :mountain_lion
  end

  def install
    system "make"
    bin.install "nrg2iso"
  end

  test do
    assert_equal "nrg2iso v#{version}",
      shell_output("#{bin}/nrg2iso --version").chomp
  end
end
