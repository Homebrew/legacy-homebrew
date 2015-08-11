class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.0.6.tar.gz"
  sha256 "95b413c82f510e406f32bbb779fe1221a3b6bf2931854f61ca44bcefc0788f50"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "ae9f777c740457c2d5698e339ac0434682f43bbc1e154cf797d586647624e5bf" => :yosemite
    sha256 "58bf476cbe2181e3a6420aa709ade2aecde6b400a70f291aeb7c3a7e747d1e05" => :mavericks
    sha256 "d5d00aeaf5f6bb6b3f2cb0d78a29271d98fa73deeb7d939055992f631da78f34" => :mountain_lion
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
