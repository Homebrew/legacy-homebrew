class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.0.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bear/bear_2.0.4.orig.tar.gz"
  sha256 "33ea117b09068aa2cd59c0f0f7535ad82c5ee473133779f1cc20f6f99793a63e"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "aff45ff41f7af8ba7e8e4417e4f9aea0a7ebadf5f9832b908262af49243be9a7" => :yosemite
    sha256 "5b88173b16b68c9c1d3882b7b1c02025619baf3efb9e099e3b72fff3f34bbc18" => :mavericks
    sha256 "2953c07183bd1ff2f5cfd30e9a1ec88c4e414d6db1acb9d35ce740dc86a83b65" => :mountain_lion
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
