class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.2.1.tar.gz"
  sha256 "eb76d3baeb5e7382d8839d7d4351794166c0b6e8d777ffe0087a3401f907e991"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19de4732fcede883809385808503dcf14594a7a8a439d709d0d8cffa98e2c646" => :el_capitan
    sha256 "19e3d77b6b033a0623245a9d7cf8cd7d2a79d8cbf8a52200da9af1a91bbec0dc" => :yosemite
    sha256 "9ca32408359ad0d0fdc1b0649e3901decf92351d6944a241861976636113ed73" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
