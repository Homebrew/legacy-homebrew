class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://zint.github.io/"
  url "https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz"
  sha256 "de2f4fd0d008530511f5dea2cff7f96f45df4c029b57431b2411b7e1f3a523e8"
  revision 1

  head "git://zint.git.sourceforge.net/gitroot/zint/zint"

  bottle do
    cellar :any
    sha256 "d3053fb59b35d60a284afbe672a5c70749b6d98181762a443934224aa87997f8" => :yosemite
    sha256 "293bd454680c7533521d2d766bdbc8c271793cd2340635c5d1dfadace12a3f1c" => :mavericks
    sha256 "1b3d656bea3766cbc955be1e348af63709b37e12acef35dac4943a712885546d" => :mountain_lion
  end

  option "with-qt", "Build the zint-qt GUI"
  deprecated_option "qt" => "with-qt"

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "qt" => :optional

  def install
    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
