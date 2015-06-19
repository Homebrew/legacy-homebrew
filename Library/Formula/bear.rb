class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.0.3.tar.gz"
  sha256 "e9d217465198453ce87237e650dedb77f92cb530a10eac53b4a062ba779bd6c1"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 "c2a70963145a8ec644ebd7c0025ced786b8311fae9d10f858649b9418dba065e" => :yosemite
    sha256 "c9b63970285cbd5b341f18dddaaed63de3cc36582aa673058111bfb05a5deecf" => :mavericks
    sha256 "5aae5f1bd8f92e2528304ecb6719f0bd495f2b7f0fb9a5051e266bcfade6ee70" => :mountain_lion
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
