require "formula"

class Bear < Formula
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/1.4.1.tar.gz"
  sha1 "79d47abfa497744b40ac39065e6ebfbe5638f6cd"

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
