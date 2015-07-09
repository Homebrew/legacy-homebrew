class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/4.9.35.tar.gz"
  sha256 "d4309a094627efdb184772df0b4ea22e8cd01c4704b56721300951d6f04d94b3"

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
    output = pipe_output(bin/"tidy5 -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
