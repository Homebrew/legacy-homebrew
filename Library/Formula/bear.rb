class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bear/bear_2.1.2.orig.tar.gz"
  sha256 "e321df1e8ff8d0b1203613e0bc5642736b4f1b1a71fd95d96b11b1e38bdbfcfc"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "d6c3a7ea4c3c03521e0ecf3fee3ac34ffe4a876d16e3976e86ed385ce1a1a6d6" => :el_capitan
    sha256 "223a11d51726424160f4615d3d13722d6051fa95ee2bf6dbd1fd8d6597a16ef0" => :yosemite
    sha256 "7acdd424b85c64d32de2ad0b3f4ad9fe93f25be215e13ba203a55204675589ad" => :mavericks
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
