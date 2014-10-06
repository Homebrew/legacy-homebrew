require "formula"

class Bear < Formula
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/1.4.3.tar.gz"
  sha1 "10a212ba608b9fae4101fb5cf8c05c4279524209"

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
