class Bear < Formula
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.0.3.tar.gz"
  sha256 "e9d217465198453ce87237e650dedb77f92cb530a10eac53b4a062ba779bd6c1"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha1 "6d868313f7e4afa2ac5e5a8979f47299e776a439" => :yosemite
    sha1 "1aa1d89fe02160069fb32c666e982c4b0fdd5841" => :mavericks
    sha1 "a576d3a8ab01c8bbdb1c387d314736d6d3c7cae7" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end
