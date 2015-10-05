class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.0.0.tar.gz"
  sha256 "44b1ab3d4aa1c4c4185bdc8b9cc4cddd4f2cc9cf2fdd679f32890844e683e7e3"

  bottle do
    cellar :any
    sha256 "ab111e194ae6477d4beb073df1a24db04121e2ffcc71333d9063f8b9d1846de8" => :el_capitan
    sha256 "d09a8455b378befb6ea26ab7bb1589c05d515b8a80351c6d588e321cc67fef4e" => :yosemite
    sha256 "38fe8f84a44ecd2631072d8bc0827d16538db5e3b6afcd927cca8de8c7f9e3c0" => :mavericks
    sha256 "aa6f64206e01fb23a0c4a2b99161df18d36339090a43b547dbd8c3ce86a5dfda" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
