class TidyHtml5 < Formula
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/4.9.26.tar.gz"
  sha256 "28674745db53b6ef1aa4b8466e6e231915dcd596672ec40515d0ab53ee0c33f6"

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
