class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.0.0.tar.gz"
  sha256 "44b1ab3d4aa1c4c4185bdc8b9cc4cddd4f2cc9cf2fdd679f32890844e683e7e3"

  bottle do
    cellar :any
    sha256 "abf02d8fef99158cfc1ed0d0d1b62cccb8739e3aeb9b36fcfe5c4605423b5438" => :yosemite
    sha256 "fac7e1a2a9bc6e567417b9d47d63bf68c46aa05937d051ff79a9e11a5c1e393f" => :mavericks
    sha256 "8b255c26049e12deca58ce8d386567f2aef061f606da4fe0161d8a4278c4718d" => :mountain_lion
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
