class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.1.25.tar.gz"
  sha256 "be81e967537984fbd207b4b19d02e7be73cbf201f07bf55aa5560c9b1d19b106"

  bottle do
    cellar :any
    sha256 "3d52b6ac9577c6ab77fcb9b1328abee5a47b8085d31c3f80a6cb3c28ae89c4c8" => :el_capitan
    sha256 "7182786c41a39091b91370ee1445d37ad570ac7004ed248fb6948482d07cddef" => :yosemite
    sha256 "d8d882a5472f72a63ed79794d4a587f1a9352ec5bd7555e529658325f66a1678" => :mavericks
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
