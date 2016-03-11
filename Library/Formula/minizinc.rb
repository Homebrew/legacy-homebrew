class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.0.12.tar.gz"
  sha256 "259cf8227c52cc4700bfe3fac8733b6a65c95ddd6431201e51c32fb9b360f171"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5a9e238379a27d47918610ea07f67a1bf5c94096b2fdd83e30ff33981536ca0" => :el_capitan
    sha256 "5f1c47c90e9a3123d0e0a5fcc7d2ef287144efb603955a55ca9424ae2cb6379f" => :yosemite
    sha256 "4308e012879a9996ab133b36c15ab6ff1a81bd69115f7561b4d87498a188831e" => :mavericks
  end

  depends_on :arch => :x86_64
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end
