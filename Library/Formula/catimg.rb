class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.2.1.tar.gz"
  sha256 "eb76d3baeb5e7382d8839d7d4351794166c0b6e8d777ffe0087a3401f907e991"
  head "https://github.com/posva/catimg.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
