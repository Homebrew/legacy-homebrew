class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/4.9.26.tar.gz"
  sha256 "28674745db53b6ef1aa4b8466e6e231915dcd596672ec40515d0ab53ee0c33f6"

  bottle do
    cellar :any
    sha256 "644d4035a1053472993ebd51cf34d88a69521d2e5beb8ed1825f4bcb6ff796f2" => :yosemite
    sha256 "46abf4003c6a17b84241ef891db85b7e5f933bd361f4834d0e15cef1c809aed8" => :mavericks
    sha256 "a465e80047d5172210e366b34acc7f0f0d251969df46b3f501b1550f53510ada" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy5 -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
