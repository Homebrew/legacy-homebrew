require "formula"

class Seexpr < Formula
  homepage "http://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/rel-1.0.1.tar.gz"
  sha1 "80890cedd684a93b012b0964dc3b59910aaf5a10"

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "doxygen"

  patch do
    # fix for macosx
    url "https://github.com/wdas/SeExpr/pull/17.diff"
    sha1 "78f209dad9f5f6bfb2751ff6b77c8a9d6ddaf8aa"
  end

  def install
    cmake_args = std_cmake_args
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    system bin/"asciigraph"
  end
end

