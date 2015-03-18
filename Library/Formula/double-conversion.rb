class DoubleConversion < Formula
  homepage "https://github.com/floitsch/double-conversion"
  url "https://github.com/floitsch/double-conversion/archive/v1.1.5.tar.gz"
  sha256 "03b976675171923a726d100f21a9b85c1c33e06578568fbc92b13be96147d932"

  head "https://github.com/floitsch/double-conversion.git"

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
