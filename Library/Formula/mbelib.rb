class Mbelib < Formula
  desc "P25 Phase 1 and ProVoice vocoder"
  homepage "https://github.com/szechyjs/mbelib"
  url "https://github.com/szechyjs/mbelib/archive/v1.2.5.tar.gz"
  sha256 "59d5e821b976a57f1eae84dd57ba84fd980d068369de0bc6a75c92f0b286c504"
  head "https://github.com/szechyjs/mbelib.git"

  bottle do
    cellar :any
    revision 1
    sha256 "d2aa6f1c7c37ad0de9d49c2a18947314f5d790888490024456f2cdc2877d05ba" => :yosemite
    sha256 "95f0f605cef097156dda1f68b451eced4c36b74a7dd520a4aa1be26d30423550" => :mavericks
    sha256 "3931a6a0b89f5b170df43b91a7e5a1e348c9b13d24d7001bda51d034cd72bef6" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
