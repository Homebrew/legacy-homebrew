class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.0.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bear/bear_2.0.4.orig.tar.gz"
  sha256 "33ea117b09068aa2cd59c0f0f7535ad82c5ee473133779f1cc20f6f99793a63e"
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
