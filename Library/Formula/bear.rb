require "formula"

class Bear < Formula
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/1.4.2.tar.gz"
  sha1 "cb46807114febb4d5ad8d24e9d6442d5fa9a7a36"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libconfig"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bear", "--", "true"
  end
end
