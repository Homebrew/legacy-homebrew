class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.0.13.tar.gz"
  sha256 "0b94f56553d162c6888d5eb336342df27cb605e0c18b01c7f2a54ee7e31dcd46"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "c764e61dc7f9e2508d9bf7fb5bb2bfa1e0d3c85521f441f9dc0e65447e30a626" => :el_capitan
    sha256 "b36ee719d486ca15850472ed50d523eca256710079e236ac879ff4c700887732" => :yosemite
    sha256 "2b48f64eabd1c4e88c71dc2c45d50fa7a6ba9fa90fc5e620de6baf2555e51ea6" => :mavericks
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
